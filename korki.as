package 
{

	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.greensock.*;
	import com.greensock.easing.*;
	import se.svt.caspar.template.CasparTemplate;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.media.Sound;

	public class korki extends CasparTemplate
	{
		var xmlLoader:URLLoader = null;
		var timer:Timer = null;
		var pozycjeX:Vector.<Number> = new Vector.<Number>();
		var pozycjeY:Vector.<Number> = new Vector.<Number>();
		var route_labels:Vector.<String> = new Vector.<String>();
		var positionCount:uint = 0;
		var positionlength:uint = 0;
		var ifOutro:Boolean = false;
		var audioFile:URLRequest = new URLRequest("KOMUNA_1_LOOP.mp3");
		var song:Sound = new Sound();
		public function korki()
		{
			// constructor code
			var myXML:XML = new XML();
			var XML_URL:String = "dane_korkowe.xml";
			var myXMLURL:URLRequest = new URLRequest(XML_URL);

			xmlLoader = new URLLoader(myXMLURL);
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			song.addEventListener(Event.COMPLETE, songLoaded);
			song.load(audioFile);

		}
		public function xmlLoaded(event:Event):void
		{
			SetData(XML(xmlLoader.data));
		}
		public override function SetData(xmlData:XML):void
		{

			mainLoader.load(new URLRequest(xmlData.mapa));
			mainLoader.addEventListener(Event.COMPLETE, fileLoaded);
			titlesLoader.load(new URLRequest(xmlData.legenda.@file));
			titlesLoader.addEventListener(Event.COMPLETE,titlesLoaded);
			legendLoader.load(new URLRequest(xmlData.route_labels[0]));
			legendLoader.addEventListener(Event.COMPLETE,legendLoaded);
			positionlength = xmlData.pozx.length();
			for (var i:uint = 0; i < xmlData.pozx.length(); i++)
			{
				pozycjeX.push(xmlData.pozx[i]);
			}
			for (var j:uint = 0; j < xmlData.pozy.length(); j++)
			{
				pozycjeY.push(xmlData.pozy[j]);
			}
			for (var k:uint = 0; k < xmlData.route_labels.length(); k++)
			{
				route_labels.push(xmlData.route_labels[k]);
			}
		}
		function fileLoaded(evt:Event):void
		{
			mainLoader.scaleContent = false;
			mainLoader.content.scaleX = 0.30;
			mainLoader.content.scaleY = 0.30;//0.14;
			mainLoader.content.x = -180;
			mainLoader.content.y = -300;
			timer = new Timer(2000);
			timer.addEventListener(TimerEvent.TIMER, introZoom);
			timer.start();
		}
		function introZoom(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER, introZoom);
			timer = null;
			TweenLite.to(titlesLoader.content, 1, {alpha:1, ease:Cubic.easeInOut});
			// to jest pierwsza pozycja
			TweenLite.to(mainLoader.content, 3, {scaleX:1, scaleY:1, x:-2360, y:-2800, ease:Cubic.easeInOut});
			positionLoop(pozycjeX[positionCount], pozycjeY[positionCount]);
		}
		function titlesLoaded(evt:Event):void
		{
			titlesLoader.content.alpha = 0;
		}
		function legendLoaded(evt:Event):void
		{
			legendLoader.content.alpha = 0;
		}
		function positionLoop(pozX:int, pozY:int):void
		{
			if (ifOutro == false)
			{
				legendLoader.load(new URLRequest(route_labels[positionCount]));
				legendLoader.addEventListener(Event.COMPLETE,legendLoaded);
				TweenLite.to(mainLoader.content, 3, {scaleX:1, scaleY:1, x:pozX, y:pozY, ease:Cubic.easeInOut, onComplete:legendShow});
			}

		}
		function legendShow():void
		{
			if (ifOutro == false)
			{
				TweenLite.to(legendLoader.content, 1, {alpha:1, ease:Cubic.easeInOut});
				waitLoop();
			}
		}
		function waitLoop():void
		{
			if (ifOutro == false)
			{
				timer = new Timer(3000);
				timer.addEventListener(TimerEvent.TIMER, legendHide);
				timer.start();
			}
		}
		function legendHide(event:TimerEvent):void
		{
			if (ifOutro == false)
			{
				timer.removeEventListener(TimerEvent.TIMER, legendHide);
				timer = null;
				if (positionCount <positionlength-1)
				{
					positionCount++;
				}
				else
				{
					positionCount = 0;
				}
				TweenLite.to(legendLoader.content, 1, {alpha:0, ease:Cubic.easeInOut, onComplete:positionLoop, onCompleteParams:[pozycjeX[positionCount], pozycjeY[positionCount]]});
			}
		}
		//overridden preDispose that will be called just before the template is removed by the template host. Allows us to clean up.
		override public function preDispose():void
		{
			//dispose the timer
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, legendHide);
			timer = null;
		}
		//overridden Stop that initiates the outro animation. IMPORTANT, it is very important when you override Stop to later call super.Stop() or removeTemplate()
		override public function Stop():void
		{
			//do the outro animation
			ifOutro = true;
			TweenLite.to(titlesLoader.content, 0.5, {alpha:0, ease:Cubic.easeInOut});
			TweenLite.to(legendLoader.content, 0.5, {alpha:0, ease:Cubic.easeInOut});
			outroAnimation();
		}
		function outroAnimation():void
		{
			TweenLite.to(mainLoader.content, 5, {scaleX:0.30, scaleY:0.30, x:-180, y:-300, ease:Cubic.easeOut, onComplete: removeTemplate});
		}
		function songLoaded(evt:Event):void
		{
			//song.play(0,100);
		}
	}
}