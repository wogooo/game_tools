package com.YFFramework.core.movie3d.skill2d
{
	/**@author yefeng
	 *2013-3-20下午9:57:31
	 * 
	 *  UV解决方案:  http://away3d.com/forum/viewthread/3411/
	 */
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Sprite3D;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	import com.YFFramework.core.movie3d.core.YFEngine;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	public class YFSprite3D extends Sprite3D
	{
		private static const DefaultBitmapData:BitmapData=new BitmapData(2,2,true,0xFFFFFFFF);
		private var _flashX:Number;
		private var _flashY:Number;
		
		protected var _bitmapTexture:BitmapTexture;
		public function YFSprite3D(width : Number=2, height : Number=2)
		{
			_bitmapTexture=new BitmapTexture(DefaultBitmapData);
			super(new TextureMaterial(_bitmapTexture), width, height);
			TextureMaterial(material).bothSides=true;
		}
		
		public function updateBitmapData(bitmapData:BitmapData):void
		{
			if(bitmapData)
			{
				_bitmapTexture.bitmapData=bitmapData;
				material.blendMode=BlendMode.LAYER;
			}
		}
			
		public function updateUVData(uvs : Vector.<Number>):void
		{
			geometry.updateUVData(uvs);
		}
		public function setFlashPosition(px:Number,py:Number):void
		{
			_flashX=px;
			_flashY=py;
			position=YFEngine.Instance.flashToModel3d(px,py);
		}
		
		public function get flashX():Number
		{
			return _flashX;
		}
		public function get flashY():Number
		{
			return _flashY;
		}
	}
}