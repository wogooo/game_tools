package yf2d.display
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.Texture;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	
	import yf2d.material.AbsMaterial;
	import yf2d.material.Sprite2DMaterial;

	/**@author yefeng
	 *20122012-11-16下午11:36:49
	 */
	public class AbsSprite2D extends Quad
	{
		protected var flashTexture:Texture;
		protected var clipSpaceMatrix:Matrix3D;
		private var colorMultiplierAndOffset:Vector.<Number> = new Vector.<Number>(8, true);// 颜色值
		protected static const offsetFactor:Number=1/255;  /// rgb 颜色偏移值
		
		protected var uvoffset:Vector.<Number>;
		
		public function AbsSprite2D(width:Number,height:Number,uvoffset:Vector.<Number>=null)
		{
			super(width,height);
			clipSpaceMatrix=new Matrix3D();
			setUVOffset(uvoffset);
			if(uvoffset==null)uvoffset=Vector.<Number>([0,0,1,1]);
			updateColorMultiplierAndOffset();
		}
		
		/** 设置材质贴图
		 */		
		public function setFlashTexture(texture:Texture):void
		{
			this.flashTexture=texture;
		}
		
		public function setUVOffset(uvoffset:Vector.<Number>):void
		{
			this.uvoffset=uvoffset;
			if(uvoffset)uvoffset.fixed=true;
		}
		
		/**渲染batch 
		 */		
		override public function render(context3d:Context3D,material:AbsMaterial):void
		{
			context3d.setTextureAt(0,flashTexture);
			processAndRenderNodes(context3d,Sprite2DMaterial(material))
			clearAfterRender(context3d);
		}
		
		protected function processAndRenderNodes(context3d:Context3D,shader2d:Sprite2DMaterial):void
		{
		//	var textureObj:Texture = texture.getTexture(context);
			
			///设置坐标矩阵  和颜色矩阵    
			if(invalidateColors) updateColors();   
			updateWorldModelMatrix3d(); 
			clipSpaceMatrix.identity();
			clipSpaceMatrix.appendScale(_width>> 1, _height>> 1, 1.0);  ///   >>  === int(value/2)
			clipSpaceMatrix.append(worldModelMatrix);
			clipSpaceMatrix.append(shader2d.cameraProjection.projection);
			
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0, clipSpaceMatrix, true);
			context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,uvoffset);
			context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX,5,colorMultiplierAndOffset); ///
			context3d.drawTriangles(shader2d.indexBuffer, 0,  2);
		}
		
		override public function updateColors():void 
		{
			super.updateColors();
			updateColorMultiplierAndOffset();
		}
		
		private function updateColorMultiplierAndOffset():void
		{
			colorMultiplierAndOffset[0] = colorTransform.redMultiplier;
			colorMultiplierAndOffset[1] = colorTransform.greenMultiplier;
			colorMultiplierAndOffset[2] = colorTransform.blueMultiplier;
			colorMultiplierAndOffset[3] = colorTransform.alphaMultiplier;
			colorMultiplierAndOffset[4] = colorTransform.redOffset * offsetFactor;
			colorMultiplierAndOffset[5] = colorTransform.greenOffset * offsetFactor;
			colorMultiplierAndOffset[6] = colorTransform.blueOffset * offsetFactor;
			colorMultiplierAndOffset[7] = colorTransform.alphaOffset * offsetFactor;
		}

		
		protected function clearAfterRender(context:Context3D):void
		{
			context.setTextureAt(0, null);
//			context.setVertexBufferAt(0, null);
//			context.setVertexBufferAt(1, null);
		}

		
		/** 更新宽高   当更新 Texture2d .setFrame函数时  有可能切换到其他贴图  照成贴图大小发生变化 这时  需要更新 宽高以适应新贴图的宽高
		 */		
		public function updateSize():void
		{
			_width=_texture.textureRect.width;
			_height=_texture.textureRect.height;
		}

		
	}
}