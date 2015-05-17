package yf2d.display
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	
	import yf2d.material.AbsMaterial;
	import yf2d.material.Sprite2DMaterial;
	import yf2d.textures.face.ITextureBase;
	
	/**@author yefeng
	 *20122012-11-16下午11:36:49
	 */
	public class AbsSprite2D extends Quad
	{
		protected var _flashTexture:Texture;
		protected var clipSpaceMatrix:Matrix3D;
		private var colorMultiplierAndOffset:Vector.<Number> = new Vector.<Number>(8, true);// 颜色值
		protected static const offsetFactor:Number=1/255;  /// rgb 颜色偏移值
		
		protected var uvoffset:Vector.<Number>;
		/**材质水平翻转
		 */		
		protected var _textureScaleX:Number;
		public function AbsSprite2D(width:Number,height:Number,uvoffset:Vector.<Number>=null)
		{
			super(width,height);
			clipSpaceMatrix=new Matrix3D();
			setUVOffset(uvoffset);
			if(uvoffset==null)uvoffset=Vector.<Number>([0,0,1,1]);
			updateColorMultiplierAndOffset();
		}
		
		/** 创建材质贴图
		 */		
		public function setFlashTexture(texture:Texture):void
		{
			this._flashTexture=texture;
		}
		
		public function getFlashTexture():Texture
		{
			return _flashTexture;
		}
		
		/**设置材质
		 */		
		public function createFlashTexture():void
		{
			
		}
		
		public function setUVOffset(uvoffset:Vector.<Number>):void
		{
			this.uvoffset=uvoffset;
			if(uvoffset)uvoffset.fixed=true;
		}
		
		/** 更新宽高   当更新 Texture2d .setFrame函数时  有可能切换到其他贴图  照成贴图大小发生变化 这时  需要更新 宽高以适应新贴图的宽高
		 */		
		public function updateSize():void
		{
			_width=_texture.rect.width;
			_height=_texture.rect.height;
		}
		/**  设置宽高 和uv 
		 * @param texture2D
		 * @param scaleX
		 */		
		public function setTextureData(texture2D:ITextureBase,scaleX:Number=1):void
		{
			_textureScaleX=scaleX;
			_texture=texture2D;
			updateSize();////更新材质大小 
			//	var rect:Rectangle=_texture.textureRect;
			setUVOffset(texture2D.getUVData(scaleX));////设置uv
		}
		/**释放 texture
		 */		
		public function disposeFlashTexture():void
		{
			if(_flashTexture)
			{
				_flashTexture.dispose();
				_flashTexture=null;	
			}
		}
		
		
		
		/**渲染batch 
		 */		
		override public function render(context3d:Context3D,material:AbsMaterial):void
		{
			if(width>=2&&height>=2)
			{	
				///设置 blendMode
				setBlendFactors(context3d);
				context3d.setTextureAt(0,_flashTexture);
				processAndRenderNodes(context3d,Sprite2DMaterial(material))
				clearAfterRender(context3d);	
			}
			
		}
		
		protected function processAndRenderNodes(context3d:Context3D,shader2d:Sprite2DMaterial):void
		{
			//	var textureObj:Texture = texture.getTexture(context);
			///设置坐标矩阵  和颜色矩阵    
			if(invalidateColors) updateColors();   
			if(invalidateMatrix||shader2d.updateCameraProjectInvalide()) //当位置变化 或者摄像头变化时 进行update 
			{
				updateWorldModelMatrix3d();
				clipSpaceMatrix.identity();
				clipSpaceMatrix.appendScale(_width>> 1, _height>> 1, 1.0);  ///   >>  === int(value/2)
				clipSpaceMatrix.append(worldModelMatrix);
				clipSpaceMatrix.append(shader2d.cameraProjection.projection);
			}
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
		/**清除 2d 数据
		 * 在整个2d都渲染完成之后调用
		 */ 
		public static function clearYF2dData(context:Context3D):void
		{
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			//			disposeFlashTexture();
			clipSpaceMatrix=null
			colorMultiplierAndOffset=null;
			uvoffset=null;
		}
		
		
	}
}