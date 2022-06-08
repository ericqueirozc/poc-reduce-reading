import 'package:flutter/material.dart';
import 'package:poc_reduced_reading/loren_ipsun_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final customScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POC Leitura Reduzida'),
      ),
      body: SingleChildScrollView(
        controller: customScrollController,
        child: ReduceReadingComponent(
            availablePercentage: 5,
            customScrollController: customScrollController),
      ),
    );
  }
}

class ReduceReadingComponent extends StatefulWidget {
  final int availablePercentage;
  final ScrollController customScrollController;
  const ReduceReadingComponent(
      {Key? key,
      required this.customScrollController,
      required this.availablePercentage})
      : super(key: key);

  @override
  State<ReduceReadingComponent> createState() => _ReduceReadingComponentState();
}

class _ReduceReadingComponentState extends State<ReduceReadingComponent> {
  double availablePercentageAsDouble = 0;
  double maxScrollExtent = 20;
  double availablePixels = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      maxScrollExtent = widget.customScrollController.position.maxScrollExtent;
      availablePercentageAsDouble = widget.availablePercentage / 100;
      availablePixels = maxScrollExtent * availablePercentageAsDouble;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final scrollPosition = widget.customScrollController.position;
    widget.customScrollController.addListener(() {
      if (scrollPosition.pixels >= availablePixels) {
        widget.customScrollController.jumpTo(availablePixels - 350);
      }
    });

    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(LorenIpsun.text),
        ),
        Column(
          children: [
            SizedBox(height: availablePixels),
            Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.9),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(.1),
                    Colors.white,
                  ],
                ),
              ),
            ),
            Container(
              height: maxScrollExtent - availablePixels - 20,
              decoration: const BoxDecoration(color: Colors.white),
            )
          ],
        )
      ],
    );
    //     });
  }
}
