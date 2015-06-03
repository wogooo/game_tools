package com.YFFramework.core.yf2d.display
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.yf2d.core.YFStageProxy;
	import com.YFFramework.core.yf2d.material.Sprite2DMaterial;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Vector3D;

	/**地表类 必须 确定 地表的    x  y 最大值 用于地表优化
	 * @author yefeng
	 * 2013 2013-8-30 上午10:24:15 
	 */
	public class AbsTileView2D extends AbsSprite2D
	{
		private var _vector3D:Vector3D;
		public function AbsTileView2D(mWidth:Number, mHeight:Number, uvoffset:Vector.<Number>=null)
		{
			super(mWidth, mHeight, uvoffset);
		}
		
		override public function render(context3d:Context3D,material:Sprite2DMaterial):void
		{
			if(_flashTexture!==null&&_scaleX!=0&&_scaleY!=0&&_visible)
			{	
				if(_invalidateColors) updateWorldColors();   
//				if(_invalidateMatrix||material.updateCameraProjectInvalide()) //当位置变化 或者摄像头变化时 进行update 
//				{
					updateWorldModelMatrix3d();
					clipSpaceMatrix.identity();
					__renderW=_width*0.5; //设置宽高      ///宽  高  向上 取整
					__renderH=_height*0.5;//_height>> 1;
					clipSpaceMatrix.appendScale(__renderW,__renderH, 1.0);  ///   >>  === int(value/2)
					clipSpaceMatrix.append(worldModelMatrix);
					clipSpaceMatrix.append(material.cameraProjection.getProjection());
					_vector3D=worldModelMatrix.position;
//					print(this,"validate..");
//				}
				if(_vector3D.x>=YFStageProxy.Instance.minX&&_vector3D.x<=YFStageProxy.Instance.maxX&&_vector3D.y>=YFStageProxy.Instance.minY&&_vector3D.y<=YFStageProxy.Instance.maxY)
				{
					///设置 blendMode
					setBlendFactors(context3d);
					context3d.setTextureAt(0,_flashTexture);
					
					context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0, clipSpaceMatrix, true);
					context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,uvoffset);
					context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX,5,colorMultiplierAndOffset); ///
					context3d.drawTriangles(material.indexBuffer, 0,  2);
					context3d.setTextureAt(0, null);
				}
			}
			
		}
	}
}