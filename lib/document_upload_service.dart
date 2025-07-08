import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'config/cloudinary_config.dart';
import 'dart:io';
import 'dart:typed_data';

class DocumentUploadService {
  // Cloudinary credentials from config
  static const String cloudName = CloudinaryConfig.cloudName;
  static const String uploadPreset = CloudinaryConfig.uploadPreset;
  
  static Future<String?> uploadDocument({
    required String loanType,
    required String docName,
    String? loanId,
  }) async {
    try {
      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Get user email for naming
      final userEmail = user.email ?? 'unknown_user';
      final sanitizedEmail = userEmail.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      
      // Pick file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      );

      if (result == null) return null;

      final fileBytes = result.files.single.bytes;
      final originalFileName = result.files.single.name;
      final fileExtension = originalFileName.split('.').last.toLowerCase();
      Uint8List? uploadBytes = fileBytes;
      if (uploadBytes == null && result.files.single.path != null) {
        try {
          final file = File(result.files.single.path!);
          uploadBytes = await file.readAsBytes();
        } catch (e) {
          // Ignore, will handle below
        }
      }
      if (uploadBytes == null) {
        throw Exception('File bytes are null. Please try picking a different file or check app permissions.');
      }

      // Generate loan ID if not provided
      final finalLoanId = loanId ?? DateTime.now().millisecondsSinceEpoch.toString();
      
      // Create organized file name
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final sanitizedLoanType = loanType.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final sanitizedDocName = docName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      
      final organizedFileName = '${sanitizedEmail}_${sanitizedLoanType}_${sanitizedDocName}_$timestamp.$fileExtension';

      // Upload to Cloudinary with organized folder structure
      final uploadUrl = 'https://api.cloudinary.com/v1_1/$cloudName/auto/upload';

      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
        ..fields['upload_preset'] = uploadPreset
        ..fields['public_id'] = 'loan_documents/$sanitizedEmail/$sanitizedLoanType/${sanitizedDocName}_$timestamp'
        ..files.add(http.MultipartFile.fromBytes('file', uploadBytes, filename: organizedFileName));

      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      final responseData = jsonDecode(responseString);

      if (response.statusCode != 200) {
        throw Exception('Upload failed: ${responseData['error']?['message'] ?? 'Unknown error'}');
      }

      final fileUrl = responseData['secure_url'];
      final publicId = responseData['public_id'];

      // Save to Firestore with comprehensive metadata
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('loans')
          .doc(finalLoanId)
          .set({
            'loanType': loanType,
            'userId': user.uid,
            'userEmail': userEmail,
            'loanId': finalLoanId,
            'uploadedDocuments.$docName': {
              'url': fileUrl,
              'publicId': publicId,
              'originalFileName': originalFileName,
              'organizedFileName': organizedFileName,
              'fileExtension': fileExtension,
              'fileSize': uploadBytes.length,
              'uploadedAt': FieldValue.serverTimestamp(),
              'documentType': docName,
            },
            'status': 'Pending',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'totalDocuments': 1, // Will be updated with actual count
          }, SetOptions(merge: true));

      // Update document count
      await _updateDocumentCount(user.uid, finalLoanId);

      return fileUrl;
    } catch (e) {
      print('Error uploading document: $e');
      rethrow;
    }
  }

  static Future<void> _updateDocumentCount(String userId, String loanId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('loans')
          .doc(loanId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['uploadedDocuments'] != null) {
          final documents = data['uploadedDocuments'] as Map<String, dynamic>;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('loans')
              .doc(loanId)
              .update({
                'totalDocuments': documents.length,
                'updatedAt': FieldValue.serverTimestamp(),
              });
        }
      }
    } catch (e) {
      print('Error updating document count: $e');
    }
  }

  static Future<Map<String, dynamic>?> getUserDocuments({
    required String loanId,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('loans')
          .doc(loanId)
          .get();

      return doc.data();
    } catch (e) {
      print('Error fetching user documents: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getUserLoans() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('loans')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching user loans: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getLoanDetails(String loanId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('loans')
          .doc(loanId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        data?['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      print('Error fetching loan details: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUserDocuments() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('loans')
          .get();

      List<Map<String, dynamic>> allDocuments = [];
      
      for (var loanDoc in querySnapshot.docs) {
        final loanData = loanDoc.data();
        final uploadedDocs = loanData['uploadedDocuments'] as Map<String, dynamic>?;
        
        if (uploadedDocs != null) {
          uploadedDocs.forEach((docName, docData) {
            if (docData is Map<String, dynamic>) {
              allDocuments.add({
                'loanId': loanDoc.id,
                'loanType': loanData['loanType'] ?? 'Unknown',
                'documentName': docName,
                'documentData': docData,
                'uploadedAt': docData['uploadedAt'],
                'userEmail': loanData['userEmail'] ?? user.email,
              });
            }
          });
        }
      }

      // Sort by upload date (newest first)
      allDocuments.sort((a, b) {
        final aDate = a['uploadedAt'] as Timestamp?;
        final bDate = b['uploadedAt'] as Timestamp?;
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return bDate.compareTo(aDate);
      });

      return allDocuments;
    } catch (e) {
      print('Error fetching all user documents: $e');
      return [];
    }
  }
} 