package org.tuio.tuioplaybook.fonts
{

	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class Style
	{
		public	static	const	COMMON_LABEL	:TextFormat = new TextFormat	(	FontName.HELVETICA_NEUE,
																					18,
																					0x333333,
																					true,
																					null,
																					null,
																					null,
																					null,
																					TextFormatAlign.LEFT
																				);
		
		public	static	const	VERSION_LABEL	:TextFormat = new TextFormat	(	FontName.HELVETICA_NEUE,
																					12,
																					0x333333,
																					true,
																					null,
																					null,
																					null,
																					null,
																					TextFormatAlign.LEFT
																				);
	}
}
