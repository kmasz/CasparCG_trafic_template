﻿package 
{

	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.greensock.TweenLite;
	import se.svt.caspar.template.CasparTemplate;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class korki extends CasparTemplate
	{

		var imagesXML:XML;
		var xmlLoader:URLLoader = null;
		private var timer:Timer;// = new Timer(2000);
		var i:uint = 0;

		public function korki()
		{
			// constructor code
			//xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			//xmlLoader.load(new URLRequest("dane_korkowe.xml"));
			var XML_URL:String = "dane_korkowe.xml";
			var myXMLURL:URLRequest = new URLRequest(XML_URL);
			xmlLoader = new URLLoader(myXMLURL);
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
		}
		/*override public function postInitialize():void
		{
		xmlLoader = new URLLoader();
		
		xmlLoader.addEventListener(Event.COMPLETE,xmlLoaded);
		//xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,xmlConfigLoadingError);
		xmlLoader.load(new URLRequest("dane_korkowe.xml"));
		}*/
		//overridden Stop that initiates the outro animation. IMPORTANT, it is very important when you override Stop to later call super.Stop() or removeTemplate()
		override public function Stop():void
		{
			//do the outro animation
		}
		//overridden Play that will initiate the intro animation and start the timer if there is data
		override public function Play():void
		{
			//do the intro animation
		}
		override public function SetData(xmlData:XML):void
		{
		//imagesXML = XML(xmlLoader.data);
		TraceToLog(xmlData.mapa);
		mainLoader.load(new URLRequest(xmlData.mapa));
		//mainLoader.load(new URLRequest("poznan_korki.png"));
		mainLoader.addEventListener(Event.COMPLETE, fileLoaded);
		//titlesLoader.load( new URLRequest(xmlData.legenda.@file));
		//titlesLoader.addEventListener(Event.COMPLETE, titlesLoaded);
		//legendLoader.load( new URLRequest(xmlData.positions[0].@file));
		//legendLoader.addEventListener(Event.COMPLETE, legendLoaded);
		//super.SetData(xmlData);
		}
		function xmlLoaded(evt:Event):void
		{
			SetData(XML(xmlLoader.data));
			//TraceToLog("dupa");
			//TraceToLog(XML(xmlLoader.data));
/*			var xmlData:XML = new XML(evt.target.data);
			//imagesXML = XML(xmlLoader.data);
			//SetData(XML(xmlLoader.data));
			TraceToLog(xmlData.componentData.mapa.@file);
			mainLoader.load(new URLRequest(xmlData.componentData.mapa.@file));
			mainLoader.addEventListener(Event.COMPLETE, fileLoaded);
			titlesLoader.load( new URLRequest(xmlData.legenda.@file));
			titlesLoader.addEventListener(Event.COMPLETE, titlesLoaded);
			legendLoader.load( new URLRequest(xmlData.positions[0].@file));
			legendLoader.addEventListener(Event.COMPLETE, legendLoaded);*/
		}
		//super.setData(imagesXML);
	//};
	function fileLoaded(evt:Event):void
	{
		mainLoader.scaleContent = false;
		//mainLoader.content.width = 1024;
		//mainLoader.content.height = 576;
		mainLoader.content.scaleX = 0.30;
		mainLoader.content.scaleY = 0.30;//0.14;
		mainLoader.content.x = -200;
		mainLoader.content.y = -300;
		timer = new Timer(2000);

		timer.addEventListener(TimerEvent.TIMER, introZoom);
		timer.start();
		////////////////////////TweenLite.to(titlesLoader.content, 1, {alpha:1});
		//TweenLite.to(mainLoader.content, 3, {scaleX:1, scaleY:1});
		//introZoom();
	}
	function titlesLoaded(evt:Event):void
	{
		titlesLoader.content.alpha = 0;
	}
	function legendLoaded(evt:Event):void
	{
		legendLoader.content.alpha = 0;
	}
	function introZoom(event:TimerEvent):void
	{
		timer.removeEventListener(TimerEvent.TIMER, introZoom);
		timer = null;
		//TweenLite.to(mainLoader.content, 1, {scaleX:1, scaleY:1});
		// to jest pierwsza pozycja
		//TweenLite.to(mainLoader.content, 3, {scaleX:1, scaleY:1, x:-2360, y:-2800});
		//TweenLite.to(legendLoader.content, 3, {alpha:1});
		//for(var i:uint = 0;i < imagesXML.positions.length(); i++)
		//{
		//positionLoop(imagesXML.positions[i].@pozx, imagesXML.positions[i].@pozy);
		//trace(imagesXML.positions[i].@pozx);
		//}

		//trace(imagesXML.positions[1].@pozx);
	}
	function positionLoop(pozX:int, pozY:int):void
	{
		// to jest pierwsza pozycja
		//TweenLite.to(mainLoader.content, 3, {scaleX:1, scaleY:1, x:-2360, y:-2800, onComplete:legendShow});
		TweenLite.to(mainLoader.content, 3, {scaleX:1, scaleY:1, x:pozX, y:pozY, onComplete:legendShow});
	}
	function legendShow():void
	{
		TweenLite.to(legendLoader.content, 1, {alpha:1});
		waitLoop();
	}
	function legendHide(event:TimerEvent):void
	{
		timer.removeEventListener(TimerEvent.TIMER, legendHide);
		timer = null;
		/*if (i < imagesXML.positions.length()-1)
		{
		i++;
		}
		else
		{
		i = 0;
		}
		trace(imagesXML.positions.length());
		TweenLite.to(legendLoader.content, 1, {alpha:0, onComplete:positionLoop, onCompleteParams:[imagesXML.positions[i].@pozx, imagesXML.positions[i].@pozy]});*/
	}
	function waitLoop():void
	{
		timer = new Timer(3000);
		timer.addEventListener(TimerEvent.TIMER, legendHide);
		timer.start();
	}

}

}