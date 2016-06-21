package 
{

	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.greensock.TweenLite;
	import se.svt.caspar.template.CasparTemplate;

	public class korki extends CasparTemplate
	{

		var imagesXML:XML;
		var xmlLoader:URLLoader = new URLLoader();

		public function korki()
		{
			// constructor code
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			xmlLoader.load(new URLRequest("dane_korkowe.xml"));
		}
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
		function xmlLoaded(evt:Event):void
		{
			imagesXML = XML(xmlLoader.data);
			mainLoader.load(new URLRequest(imagesXML.mapa.@file));
			mainLoader.addEventListener(Event.COMPLETE, fileLoaded);
			titlesLoader.load( new URLRequest(imagesXML.legenda.@file));
			titlesLoader.addEventListener(Event.COMPLETE, titlesLoaded);
			legendLoader.load( new URLRequest(imagesXML.opis1.@file));
			legendLoader.addEventListener(Event.COMPLETE, legendLoaded);
		}
		function fileLoaded(evt:Event):void
		{
			mainLoader.scaleContent = false;
			//mainLoader.content.width = 1024;
			//mainLoader.content.height = 576;
			mainLoader.content.scaleX = 0.25;
			mainLoader.content.scaleY = 0.14;
			//TweenLite.to(mainLoader.content, 3, {scaleX:1, scaleY:1});
			introZoom();
		}
		function titlesLoaded(evt:Event):void
		{
			titlesLoader.content.alpha = 0;
		}
		function legendLoaded(evt:Event):void
		{
			legendLoader.content.alpha = 0;
		}
		function introZoom():void
		{
			//TweenLite.to(mainLoader.content, 1, {scaleX:1, scaleY:1});
			TweenLite.to(mainLoader.content, 1, {scaleX:1, scaleY:1, x:-2360, y:-2800});
			TweenLite.to(titlesLoader.content, 1, {alpha:1});
			TweenLite.to(legendLoader.content, 1, {alpha:1});
		}

	}

}