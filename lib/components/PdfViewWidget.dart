import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PdfViewWidget extends StatefulWidget {
  static String tag = '/pdfViewWidget';
  final String? pdfUrl;

  PdfViewWidget({this.pdfUrl});

  @override
  PdfViewWidgetState createState() => PdfViewWidgetState();
}

class PdfViewWidgetState extends State<PdfViewWidget> {
  late final WebViewController wbController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setOrientationPortrait();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final wv = WebView(
      initialUrl: Uri.dataFromString(getPdfBodyScript(), mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString(),
      javascriptMode: JavascriptMode.unrestricted,
      initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      onWebViewCreated: (wbc) {
        wbController = wbc;
      },
    );
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 26),
        width: context.width(),
        height: context.height(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: () => finish(context), icon: Icon(Icons.arrow_back)),
            SizedBox(
              height: context.height(),
              width: context.width(),
              child: wv,
            ).expand(),
          ],
        ),
      ),
    );
  }

  String getPdfBodyScript() => """
      <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          
            <script
              src="http://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.0.943/pdf.min.js">
            </script>
            
          <style>
            *{
               box-sizing: border-box;
               margin:0px; 
               padding:0px;
            }
            #my_pdf_viewer {
               margin: 4px; 
               text-align: center;
            }
            #canvas_container {
              width: 100%;
              height: 90%;
              overflow: auto;
            }
            #canvas_container {
              background: #333;
              border: solid 1px #808080;
            }
            #zoom_in, #zoom_out, #go_previous, #go_next {
              background-color: #cc1c2c;
              border: none;
              color: white;
              padding: 5px 20px;
              text-align: center;
              text-decoration: none;
              display: inline-block;
              font-size: 22px;
              margin: 6px 2px;
              border-radius: 4px;
            }
          </style>
        </head>
      <body>
         <div id="my_pdf_viewer">
            <div id="canvas_container">
                <canvas id="pdf_renderer"></canvas>
            </div>
               
                <button id="go_previous"> < </button>       
                <button id="zoom_in">+</button>
                <button id="zoom_out">-</button>
                <button id="go_next"> > </button>
                
          <script>
              var myState = {
                  pdf: null,
                  currentPage: 1,
                  zoom: 0.8
              }
            
              pdfjsLib.getDocument('${widget.pdfUrl.validate()}').then((pdf) => {
                  myState.pdf = pdf;
                  render();
              });
      
              function render() {
                  myState.pdf.getPage(myState.currentPage).then((page) => {
                
                      var canvas = document.getElementById("pdf_renderer");
                      var ctx = canvas.getContext('2d');
            
                      var viewport = page.getViewport(myState.zoom);
      
                      canvas.width = viewport.width;
                      canvas.height = viewport.height;
                
                      page.render({
                          canvasContext: ctx,
                          viewport: viewport
                      });
                  });
              }
      
              document.getElementById('go_previous').addEventListener('click', (e) => {
                  if(myState.pdf == null || myState.currentPage == 1) 
                    return;
                  myState.currentPage -= 1;
                  render();
              });
      
              document.getElementById('go_next').addEventListener('click', (e) => {
                  if(myState.pdf == null || myState.currentPage > myState.pdf._pdfInfo.numPages) 
                     return;
                  myState.currentPage += 1;
                  render();
              });
            
              document.getElementById('zoom_in').addEventListener('click', (e) => {
                  if(myState.pdf == null) return;
                  myState.zoom += 0.1;
                  render();
              });
      
              document.getElementById('zoom_out').addEventListener('click', (e) => {
                  if(myState.pdf == null) return;
                  myState.zoom -= 0.1;
                  render();
              });
          </script>
      </body>
  </html>
  """;
}
