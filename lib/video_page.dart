
import 'dart:convert';
import 'video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class HomePage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }

}

class HomePageState extends State<HomePage> {
  ScrollController _controller=ScrollController();
  final _middlePadding = 10.0 ; // padding of centered items
  final _edgesPadding = 15.0 ; // padding of non-centered items
  final _itemSize = 310.0 ;
  final int _centeredItems = 1 ;
  int _numberOfEdgesItems =0; // number of items which aren't centered at any moment
  int _aboveItems =0; // number of items above the centered ones
  int _belowItems =0; // number of items below the centered ones;
  bool scroll = false;
  @override
  void initState() {
    _controller = ScrollController(); // Initializing ScrollController
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),

      child: AppBar(
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(10),
          centerTitle: true,
        title: const Text('YellowClass'),),
      backgroundColor: Colors.transparent,

        leading: Container(
          padding: EdgeInsets.all(12),
          child: CircleAvatar(
            child: Image.asset('assets/log.png'),
          )


        ),
      ),
      ),
      body:Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFF701ebd),
                Color(0xFF873bcc),
                Color(0xFFfe4a97),
                Color(0xFFe17763),
                Color(0xFF68998c)
              ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft

          )
        ),
        child: FutureBuilder<List<Video>>(
            future: getVideoDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return const Center(child: CircularProgressIndicator());
              }
              else {
                return NotificationListener(
                  child: ListView.builder(
                      controller: _controller ,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        // This is how to calculate number of non-centered Items
                        _numberOfEdgesItems = ( (MediaQuery.of(context).size.height - _centeredItems*(_itemSize + 2*(_middlePadding))) ~/ (_itemSize + 2*(_edgesPadding)) ) ;

                        _aboveItems = ( ( (_controller.offset) / (_itemSize + 2*(_edgesPadding)) ) + _numberOfEdgesItems/2 ).toInt() ;

                        _belowItems = _aboveItems + _centeredItems ;

                        return Container(
                          color: Colors.transparent,
                          child: Card(
                            color: Colors.transparent,
                            child: Container(
                              color:  index >= _aboveItems && index < _belowItems && scroll ? Colors.transparent:Colors.transparent,
                              height: _itemSize,
                              child: Column(
                                children: [
                                  index >= _aboveItems && index < _belowItems && scroll ?Expanded(child: VideoPlayerRemote(url: snapshot.data![index].videoUrl)):Image.network(snapshot.data![index].cover,fit: BoxFit.fill,),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(

                                              child: Text(snapshot.data![index].id.toString(),style: const TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold,color: Colors.lightGreen)),
                                              backgroundColor: Colors.white,
                                            ),
                                          ),

                                          Text(snapshot.data![index].title,style: const TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold,color: Colors.white)),
                                        ]
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  onNotification: (notificationInfo) {
                    if (notificationInfo is ScrollStartNotification) {
                      scroll=false;
                      setState((){});
                    }
                    if (notificationInfo is ScrollEndNotification) {
                      scroll=true;
                      setState((){});
                    }
                    return true;
                  },
                );
              }
            }
        ),
      ),
    );
  }
  Future<List<Video>> getVideoDetails() async{
    String r=await rootBundle.loadString('assets/dataset.json');
    var x= jsonDecode(r);
    List<Video> y=[];
    for(var i in x)
    {
      y.add(Video(i["id"],i['title'],i['coverPicture'],i['videoUrl']));
    }
    return y;
  }
}

class Video {
  var id;
  var title;
  var videoUrl;
  var cover;

  Video(this.id, this.title, this.cover, this.videoUrl);
}
