package yf2d.display
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	
	import yf2d.material.AbsMaterial;
	import yf2d.material.BatchMaterial;
                                                          
	/** 
	 * author :夜枫
	 * Sprite2d 的子对象 最好是 Quad 的子类型      也可以是 Sprite2d类型 但是这时将会忽略 子对象中Sprite2d 
	 * 为了 创建纯粹的容器 最好是 使用 DisplayObjectContainer2d
	 * 
	 */
	public class SpriteBatch extends DisplayObjectContainer2D
	{
		protected static const offsetFactor:Number=1/255;  /// rgb 颜色偏移值
		protected var texture:Texture;
		protected var clipSpaceMatrix:Matrix3D;
		protected  var batchLen:int=0;
		public function SpriteBatch(texture:Texture)
		{
			super();
			clipSpaceMatrix=new Matrix3D();
			setTexture(texture);
		}
		
		/**渲染batch 
		 */		
		override public function render(context3d:Context3D,shader2d:AbsMaterial):void
		{
			context3d.setTextureAt(0,texture);
			batchLen=0;         
			processAndRenderNodes(context3d,BatchMaterial(shader2d),_children);
			if(batchLen != 0)
			{
				context3d.drawTriangles(shader2d.indexBuffer, 0, batchLen * 2);
			}
		}
		/** 设置材质贴图
		 */		
		public function setTexture(texture:Texture):void
		{
			///释放前一材质贴图
	//		if(this.texture) this.texture.dispose();
			this.texture=texture;
		}
		
		private var child:DisplayObject2D;
		private var colorMultiplierAndOffset:Vector.<Number> = new Vector.<Number>(8, true);// 颜色值
		private var uvoffset:Vector.<Number> ;//= new Vector.<Number>(4, true);   //// uv 值
		//	var i:int = -1;
 
		
		/** 渲染匹配batchZize 进行处理
		 */		
		protected function processAndRenderNodes(context3d:Context3D,shader2d:BatchMaterial,childList:Vector.<DisplayObject2D>):void
		{
			//var child:DisplayObject2d;
			//var colorMultiplierAndOffset:Vector.<Number> = new Vector.<Number>(8, true);// 颜色值
			//var uvoffset:Vector.<Number> ;//= new Vector.<Number>(4, true);   //// uv 值
		//	var i:int = -1;
			var n:int = childList.length;
			//while(++i<n)
			while(n)
			{
			//	child=childList[i];
				child=childList[n-1];
				n--;
				if(child.visible)
				{
					
					if(child is Quad)//当为显示对象时
					{
						///设置坐标矩阵  和颜色矩阵                                      
					//	if(child.invalidateMatrix)	child.updateLocalModelMatrix3d();   内部实现 
						if(child.invalidateColors) child.updateColors();   
						child.updateWorldModelMatrix3d(); 
						clipSpaceMatrix.identity();
						clipSpaceMatrix.appendScale(child._width>> 1, child._height>> 1, 1.0);  ///   >>  === int(value/2)
						clipSpaceMatrix.append(child.worldModelMatrix);
						clipSpaceMatrix.append(shader2d.cameraProjection.projection);
						
						colorMultiplierAndOffset[0] = child.colorTransform.redMultiplier;
						colorMultiplierAndOffset[1] = child.colorTransform.greenMultiplier;
						colorMultiplierAndOffset[2] = child.colorTransform.blueMultiplier;
						colorMultiplierAndOffset[3] = child.colorTransform.alphaMultiplier;
						colorMultiplierAndOffset[4] = child.colorTransform.redOffset * offsetFactor;
						colorMultiplierAndOffset[5] = child.colorTransform.greenOffset * offsetFactor;
						colorMultiplierAndOffset[6] = child.colorTransform.blueOffset * offsetFactor;
						colorMultiplierAndOffset[7] = child.colorTransform.alphaOffset * offsetFactor;
   
						uvoffset=Quad(child).texture.getUVData();
						context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,BatchMaterial.ConstantsPerSprite*batchLen, clipSpaceMatrix, true);
						context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX,BatchMaterial.ConstantsPerSprite*batchLen+BatchMaterial.ConstantPerMatrix,colorMultiplierAndOffset);
						context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX,BatchMaterial.ConstantsPerSprite*batchLen+BatchMaterial.ConstantPerMatrix+1,uvoffset);
						++batchLen;
						if(batchLen == BatchMaterial.BatchSize) 
						{
							context3d.drawTriangles(shader2d.indexBuffer, 0, batchLen * 2);
							batchLen = 0;
						}
					}
					else if(child is DisplayObjectContainer2D)   ////当为容器时
					{
					//	shader2d.setTexture(Sprite2d(child).textureData);///设置贴图   
						processAndRenderNodes(context3d, shader2d,DisplayObjectContainer2D(child)._children);    	// ///多次递归调用 一次处理2*128/ 7   个三角形
					}
				}
			}
			
		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			texture.dispose();
			texture=null;
			clipSpaceMatrix=null;
		}
	}
}