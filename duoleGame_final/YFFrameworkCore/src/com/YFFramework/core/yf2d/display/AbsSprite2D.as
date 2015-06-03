package com.YFFramework.core.yf2d.display
{
	import com.YFFramework.core.yf2d.material.Sprite2DMaterial;
	import com.YFFramework.core.yf2d.textures.face.ITextureBase;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix3D;
	
	/**@author yefeng
	 *20122012-11-16下午11:36:49
	 */
	public class AbsSprite2D extends Quad
	{
		protected var _flashTexture:TextureBase;
		protected var clipSpaceMatrix:Matrix3D;
		protected var colorMultiplierAndOffset:Vector.<Number> ;//=Vector.<Number>([1,1,1,1,0,0,0,0]); // new Vector.<Number>(8, true);// 颜色值
		protected static const offsetFactor:Number=1/255;  /// rgb 颜色偏移值
		
		protected var uvoffset:Vector.<Number>;
		/**材质水平翻转
		 */		
		protected var _textureScaleX:Number;
		protected var _textureScaleY:Number;

		/**渲染宽
		 */		
		protected var __renderW:Number;
		/**渲染高
		 */		
		protected var __renderH:Number;
		public function AbsSprite2D(mWidth:Number,mHeight:Number,uvoffset:Vector.<Number>=null)
		{
			super(mWidth,mHeight);
			clipSpaceMatrix=new Matrix3D();
			if(uvoffset==null)uvoffset=Vector.<Number>([0,0,1,1]);
			else setUVOffset(uvoffset);
			colorMultiplierAndOffset=new Vector.<Number>();
			colorMultiplierAndOffset.push(1,1,1,1,0,0,0,0);
			colorMultiplierAndOffset.fixed=true;
		}
		
		/** 创建材质贴图
		 */		
		public function setFlashTexture(texture:TextureBase):void
		{
			this._flashTexture=texture;
		}
		
		public function getFlashTexture():TextureBase
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
			__renderW=_width*0.5; //设置宽高      ///宽  高  向上 取整
			__renderH=_height*0.5;//_height>> 1;
		}
		/**  设置宽高 和uv 
		 * @param texture2D
		 * @param scaleX
		 */		
		public function setTextureData(texture2D:ITextureBase,scaleX:Number=1,scaleY:Number=1):void
		{
			_textureScaleX=scaleX;
			_textureScaleY=scaleY;
			_texture=texture2D;
			updateSize();////更新材质大小 
			//	var rect:Rectangle=_texture.textureRect;
			setUVOffset(texture2D.getUVData(scaleX,scaleY));////设置uv
		}
		
		public function getTextureScaleX():Number
		{
			return _textureScaleX;
		}
		public function getTextureScaleY():Number
		{
			return _textureScaleY;
		}

		
		/**释放 texture
		 *  动画MovieClip不要调用该方法
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
		override public function render(context3d:Context3D,material:Sprite2DMaterial):void
		{
			if(_flashTexture!==null&&_scaleX!=0&&_scaleY!=0&&_visible&&_isDispose==false)
			{	
//				Program3DManager.setProgram(programId);
				///设置 blendMode
				setBlendFactors(context3d);
				context3d.setTextureAt(0,_flashTexture);
				processAndRenderNodes(context3d,material);
				context3d.setTextureAt(0, null);
			}
			
		}
		
		protected function processAndRenderNodes(context3d:Context3D,shader2d:Sprite2DMaterial):void
		{
			///设置坐标矩阵  和颜色矩阵    
	//		if(_invalidateColors) updateWorldColors();  ///只要   为 true 就 直接  调用 而不是在渲染的时候调用
			
//			if(_invalidateMatrix||shader2d.updateCameraProjectInvalide()) //当位置变化 或者摄像头变化时 进行update 
//			{
				updateWorldModelMatrix3d();
				clipSpaceMatrix.identity();
//				__renderW=_width*0.5; //设置宽高      ///宽  高  向上 取整   //在updateSize的时候处理好
//				__renderH=_height*0.5;//_height>> 1;
				clipSpaceMatrix.appendScale(__renderW,__renderH, 1.0);  ///   >>  === int(value/2)
				clipSpaceMatrix.append(worldModelMatrix);
				clipSpaceMatrix.append(shader2d.cameraProjection.getProjection());
//			}
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0, clipSpaceMatrix, true);
			context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,uvoffset);
			context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX,5,colorMultiplierAndOffset); ///
			context3d.drawTriangles(shader2d.indexBuffer, 0,  2);
		}
		
		override public function updateWorldColors():void 
		{
			super.updateWorldColors();
			updateColorMultiplierAndOffset();
		}
		
		private function updateColorMultiplierAndOffset():void
		{
			colorMultiplierAndOffset[0] = _worldColorTransform.redMultiplier;
			colorMultiplierAndOffset[1] = _worldColorTransform.greenMultiplier;
			colorMultiplierAndOffset[2] = _worldColorTransform.blueMultiplier;
			colorMultiplierAndOffset[3] = _worldColorTransform.alphaMultiplier;
			colorMultiplierAndOffset[4] = _worldColorTransform.redOffset * offsetFactor;
			colorMultiplierAndOffset[5] = _worldColorTransform.greenOffset * offsetFactor;
			colorMultiplierAndOffset[6] = _worldColorTransform.blueOffset * offsetFactor;
			colorMultiplierAndOffset[7] = _worldColorTransform.alphaOffset * offsetFactor;
		}
		
		
//		protected function clearAfterRender(context:Context3D):void
//		{
//			context.setTextureAt(0, null);
//			//			context.setVertexBufferAt(0, null);
//			//			context.setVertexBufferAt(1, null);
//		}
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
			clipSpaceMatrix=null
			colorMultiplierAndOffset=null;
			uvoffset=null;
			_flashTexture=null;
		}
		

		
		
	}
}