import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebView Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'WebView Login Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textEditingController = TextEditingController.fromValue(TextEditingValue(text: 'https://www.udemy.com/'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _textEditingController,
              ),
            ),
            FlatButton(
              color: Colors.amberAccent,
              child: Text('launch WebView'),
              onPressed: () => WebViewPage.navigateTo(context, _textEditingController.text),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  final String url;

  WebViewPage(this.url);

  static void navigateTo(BuildContext context, String url) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewPage(url)),
    );

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      body: SafeArea(
        child: Container(
          child: InAppWebView(
            initialUrl: widget.url,
            initialOptions: InAppWebViewGroupOptions(
              android: AndroidInAppWebViewOptions(
                  allowContentAccess: true,
                  builtInZoomControls: true,
                  thirdPartyCookiesEnabled: true,
                  allowFileAccess: true,
                  supportMultipleWindows: true
              ),
              crossPlatform: InAppWebViewOptions(
                disableContextMenu: false,
                javaScriptCanOpenWindowsAutomatically: true,
                debuggingEnabled: true,
                transparentBackground: true,
              ),
            ),
            onCreateWindow: _onCreateWindow,
          ),
        ),
      ),
    );
  }

  bool _isWindowDisplayed = false;

  Future<bool> _onCreateWindow(InAppWebViewController controller, CreateWindowRequest createWindowRequest) async {
    _isWindowDisplayed = true;
    showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(2.0),
          insetPadding: EdgeInsets.all(20.0),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: InAppWebView(
              // Setting the windowId property is important here!
              windowId: createWindowRequest.windowId,
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  builtInZoomControls: true,
                  thirdPartyCookiesEnabled: true,
                ),
                crossPlatform: InAppWebViewOptions(
                    userAgent: "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36"
                ),
              ),
              onCloseWindow: (controller) {
                // On Facebook Login, this event is called twice,
                // so here we check if we already popped the alert dialog context
                if (_isWindowDisplayed) {
                  Navigator.pop(context);
                  _isWindowDisplayed = false;
                }
              },
            ),
          ),
        );
      },
    );
    return true;
  }
}

