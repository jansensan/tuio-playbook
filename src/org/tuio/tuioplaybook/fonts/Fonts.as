package org.tuio.tuioplaybook.fonts
{
	import flash.text.Font;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class Fonts
	{
		[Embed(	source="assets/fonts/HelveticaNeue.dfont",
				fontName="Helvetica Neue",
				mimeType="application/x-font",
				embedAsCFF="false"
		)]
		private	const	HelveticaNeue	:Class;


		public function traceEmbeddedFonts():void
		{
			trace("\n", this, "--- traceEmbeddedFonts ---");
			
			var embeddedFonts:Array = Font.enumerateFonts(false);
			var font:Font;
			var i:int = 0;
			var numLoops:int = embeddedFonts.length;
			for(i; i < numLoops; i++)
			{
				font = embeddedFonts[i];
				trace("\t[" + i + "]\nfontName:\t" + font.fontName + ",\nstyle:\t" + font.fontStyle + ",\ntype:\t" + font.fontType + "\n");
			}
		}
	}
}
