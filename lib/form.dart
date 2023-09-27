import 'package:gsheets/gsheets.dart';
import 'package:tuple/tuple.dart';

Future<Tuple2<Map<String, String>?, String>> getParticipant(
    Spreadsheet ss, String? email, String volunteer) async {
  var scanSheet = ss.worksheetByTitle('Scan Results');
  var formSheet = ss.worksheetByTitle('Form Responses 1');

  if (email == null) {
    return const Tuple2(null, "Email is null!");
  }

  if (scanSheet == null || formSheet == null) {
    return const Tuple2(null, "Form not Found!");
  }

  var emailsFuture = formSheet.values.column(2); // TIN -> 5
  var pFuture = scanSheet.values.map.rowByKey(
    email, fromColumn: 1, // email column
  );

  var emails = await emailsFuture;
  var index = emails.indexOf(email);
  if (index == -1) {
    return const Tuple2(null, "User is not Registered!");
  }

  var scan = await pFuture;
  if (scan == null) {
    scanSheet.values.appendRow([email, volunteer, "Scanned", DateTime.now().toString()]);
    return Tuple2(await formSheet.values.map.row(index + 1), "User Found!");
  }

  return const Tuple2(null, "User Scanned!"); // user scanned
}
