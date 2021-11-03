import 'package:flutter/material.dart';
import 'package:torus_direct/torus_direct.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omnigate Amplify-Torus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sign In'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _privateKey = '';

  @override
  void initState() {
    super.initState();
    initTorusDirect();
  }

  /// Initializes a TorusDirect instance
  Future<void> initTorusDirect() async {
    await TorusDirect.init(
      network: TorusNetwork.testnet,
      redirectUri: Uri.parse(
          'https://amplifytorus102ead18-102ead18-staging.auth.us-east-2.amazoncognito.com/'
          //'https://amplifytorus102ead18-102ead18-staging.auth.us-east-2.amazoncognito.com/login?response_type=code&client_id=oeb4fs3fv8ij1f5e81c9iqdh0&redirect_uri=myapp://'
          //'torusapp://org.torusresearch.torusdirectandroid/redirect'
          //'https://amplifytorus102ead18-102ead18-staging.auth.us-east-2.amazoncognito.com/oauth2/idpresponse',
          ),
    );
  }

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
            MaterialButton(
              onPressed: torusLogin,
              child: const Text('Sign in'),
            ),
            const SizedBox(height: 20),
            Text('Torus Private Key: $_privateKey'),
          ],
        ),
      ),
    );
  }

  /// Log in with Torus using JWT token from AWS Cognito with Google as the identity provider
  Future<void> torusLogin() async {
    try {
      final TorusCredentials credentials = await TorusDirect.triggerLogin(
        typeOfLogin: TorusLogin.jwt,
        verifier: 'omnigateexample',
        clientId: '3875ejqbq7q3kfg1n8vfdjpb8t',
        jwtParams: {
          "domain":
              "https://amplifytorus102ead18-102ead18-staging.auth.us-east-2.amazoncognito.com/",
          "user_info_endpoint": "userInfo"
        },
      );

      setState(() {
        _privateKey = credentials.privateKey;
      });
    } on UserCancelledException {
      print("User cancelled");
    } on NoAllowedBrowserFoundException {
      print('No allowed browser found');
    } on Exception catch (e) {
      print(e);
    }
  }
}
