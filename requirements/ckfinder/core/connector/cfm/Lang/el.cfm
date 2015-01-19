<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object for the Greek language.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Η ενέργεια δεν ήταν δυνατόν να εκτελεστεί. (Σφάλμα %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Λανθασμένη Εντολή.';
	CKFLang.Errors[11] = 'Το resource type δεν ήταν δυνατόν να προσδιοριστεί.';
	CKFLang.Errors[12] = 'Το resource type δεν είναι έγκυρο.';
	CKFLang.Errors[102] = 'Το όνομα αρχείου ή φακέλου δεν είναι έγκυρο.';
	CKFLang.Errors[103] = 'Δεν ήταν δυνατή η εκτέλεση της ενέργειας λόγω έλλειψης δικαιωμάτων ασφαλείας.';
	CKFLang.Errors[104] = 'Δεν ήταν δυνατή η εκτέλεση της ενέργειας λόγω περιορισμών του συστήματος αρχείων.';
	CKFLang.Errors[105] = 'Λανθασμένη επέκταση αρχείου.';
	CKFLang.Errors[109] = 'Λανθασμένη ενέργεια.';
	CKFLang.Errors[110] = 'Άγνωστο λάθος.';
	CKFLang.Errors[111] = 'It was not possible to complete the request due to resulting file size.';
	CKFLang.Errors[115] = 'Το αρχείο ή φάκελος υπάρχει ήδη.';
	CKFLang.Errors[116] = 'Ο φάκελος δεν βρέθηκε. Παρακαλούμε ανανεώστε τη σελίδα και προσπαθήστε ξανά.';
	CKFLang.Errors[117] = 'Το αρχείο δεν βρέθηκε. Παρακαλούμε ανανεώστε τη σελίδα και προσπαθήστε ξανά.';
	CKFLang.Errors[118] = 'Η αρχική και τελική διαδρομή είναι ίδιες.';
	CKFLang.Errors[201] = 'Ένα αρχείο με την ίδια ονομασία υπάρχει ήδη. Το μεταφορτωμένο αρχείο μετονομάστηκε σε "%1".';
	CKFLang.Errors[202] = 'Λανθασμένο αρχείο.';
	CKFLang.Errors[203] = 'Λανθασμένο αρχείο. Το μέγεθος του αρχείου είναι πολύ μεγάλο.';
	CKFLang.Errors[204] = 'Το μεταφορτωμένο αρχείο είναι χαλασμένο.';
	CKFLang.Errors[205] = 'Δεν υπάρχει προσωρινός φάκελος για να χρησιμοποιηθεί για τις μεταφορτώσεις των αρχείων.';
	CKFLang.Errors[206] = 'Η μεταφόρτωση ακυρώθηκε για λόγους ασφαλείας. Το αρχείο περιέχει δεδομένα μορφής HTML.';
	CKFLang.Errors[207] = 'Το μεταφορτωμένο αρχείο μετονομάστηκε σε "%1".';
	CKFLang.Errors[300] = 'Η μετακίνηση των αρχείων απέτυχε.';
	CKFLang.Errors[301] = 'Η αντιγραφή των αρχείων απέτυχε.';
	CKFLang.Errors[500] = 'Ο πλοηγός αρχείων έχει απενεργοποιηθεί για λόγους ασφαλείας. Παρακαλούμε επικοινωνήστε με τον διαχειριστή της ιστοσελίδας και ελέγξτε το αρχείο ρυθμίσεων του πλοηγού (CKFinder).';
	CKFLang.Errors[501] = 'Η υποστήριξη των μικρογραφιών έχει απενεργοποιηθεί.';
</cfscript>
</cfsilent>
