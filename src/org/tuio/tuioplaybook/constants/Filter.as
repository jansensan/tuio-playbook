package org.tuio.tuioplaybook.constants
{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class Filter
	{
		public	static	const	COMMON_LABEL_DROP_SHADOW		:DropShadowFilter = new DropShadowFilter	(	1,		// distance
																												90,		// angle
																												0xffffff,
																												1,	// alpha
																												0,		// blurX
																												0,		// blurY
																												2,		// strength
																												BitmapFilterQuality.HIGH
																											);
	}
}
