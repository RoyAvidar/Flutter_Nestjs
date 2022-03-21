import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const sendEmailGraphql = """
  query
    sendEmail(\$content: String!) {
      sendEmail(content: \$content)
    }
""";

class ReportBugScreen extends StatefulWidget {
  static const routeName = "/report-bug";
  const ReportBugScreen({Key? key}) : super(key: key);

  @override
  _ReportBugScreenState createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends State<ReportBugScreen> {
  TextEditingController bugReportController = TextEditingController();
  bool _validate = false;

  Future<bool> _sendBugReport(String content) async {
    QueryOptions queryOptions = QueryOptions(
        document: gql(sendEmailGraphql),
        variables: <String, dynamic>{
          "content": content,
        });
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final isSent = result.data?["sendEmail"];
    return isSent;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bugReportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Bug Report"),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 15, top: 35, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Did you find something wrong with the app?",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 10),
              TextField(
                maxLines: null,
                minLines: 2,
                keyboardType: TextInputType.multiline,
                autocorrect: false,
                autofocus: false,
                controller: bugReportController,
                decoration: InputDecoration(
                  errorText: _validate ? "Text is empty" : null,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "I've found a bug in...",
                  floatingLabelStyle: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      setState(() {
                        bugReportController.text = "";
                      });
                    },
                    child: Text("clear"),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      setState(() {
                        bugReportController.text.isEmpty
                            ? _validate = true
                            : _validate = false;
                      });
                      if (!_validate) {
                        final emailSent =
                            await _sendBugReport(bugReportController.text);
                        emailSent
                            ? ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Thank you for your bug report!',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              )
                            : ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Invalid login error: Username and Password not accepted.',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  duration: Duration(seconds: 4),
                                ),
                              );
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("Send"),
                  ),
                ],
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
