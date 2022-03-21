import 'package:flutter/material.dart';
import 'package:flutter_main/screens/reviews_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_main/providers/reviews.dart';

class EditReviewScreen extends StatefulWidget {
  const EditReviewScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-review';

  @override
  State<EditReviewScreen> createState() => _EditReviewScreenState();
}

class _EditReviewScreenState extends State<EditReviewScreen> {
  TextEditingController editReviewController = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    // TODO: implement dispose
    editReviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int reviewId = ModalRoute.of(context)!.settings.arguments as int;
    final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reviews'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Edit your review:"),
                TextField(
                  decoration: InputDecoration(
                    labelText: "enter text here",
                    errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  ),
                  controller: editReviewController,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, "Cancel"),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          editReviewController.text.isEmpty
                              ? _validate = true
                              : _validate = false;
                        });
                        if (_validate) {
                          return;
                        }
                        Provider.of<ReviewsProvider>(context, listen: false)
                            .updateReviewContent(
                                reviewId, editReviewController.text);
                        Navigator.of(context)
                            .pushNamed(ReviewsScreen.routeName);
                      },
                      child: Text(
                        "Save Changes",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
