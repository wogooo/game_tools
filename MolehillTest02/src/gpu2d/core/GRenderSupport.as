package gpu2d.core
{
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import gpu2d.display.GDisplayObject;
	import gpu2d.display.GDisplayObjectContainer;
	import gpu2d.errors.SingletonError;
	import gpu2d.utils.GMath;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-21 下午02:24:22
	 * 
	 *  该类的 作用是进行 矩阵转化   进行渲染 绘制到屏幕上 所要用到的矩阵
	 */
	public final class GRenderSupport
	{
		private static var _instance:GRenderSupport;
		private var W:Number;
		private var H:Number;
		public function GRenderSupport()
		{
			if(_instance) throw new SingletonError();
		}
		public static function get Instance():GRenderSupport
		{
			if(!_instance) _instance=new GRenderSupport();
			return _instance;
		}
		internal function configureWH(stageW:Number,stageH:Number):void
		{
			W=stageW;
			H=stageH;
		}
		/**得到转化后的矩阵    单一的
		 */		
		/*public function getConvertMatrix2(obj:GDisplayObject):Vector.<Number>
		{
			var matrxi:Matrix=new Matrix();
			var tmpRotation:Number=obj.rotation;
			obj.rotation=0;
			var objWidth:Number=obj.width;
			var objHeight:Number=obj.height;
			obj.rotation=tmpRotation;
			
			var pivot_x:Number=(W*0.5-W*obj.pivotX/objWidth)*2/W;///百分比
			var pivot_y:Number=(H*obj.pivotY/objHeight-H*0.5)*2/H; ///百分比
			
			//	degree=0
			//matrxi.translate(1,-1); ///移动注册点///向右向下 移动注册点
			matrxi.translate(pivot_x,pivot_y); ///移动注册点
			matrxi.rotate(GMath.DegreeToRadian(-obj.rotation));  //旋转必须放在第一位
			matrxi.translate(-pivot_x,-pivot_y);   ///恢复移动前的状态
			matrxi.scale(objWidth/W,objHeight/H);
			//	matrxi.scale(-1,1)
			///设置坐标
			matrxi.translate((obj.x+objWidth*0.5-W*0.5)*2/W,-(obj.y+objHeight*0.5-H*0.5)*2/H);
			//
			var _matrixVector:Vector.<Number>=new Vector.<Number>();
			////  a   c  0    tx         b d    ty   0
			_matrixVector.push(matrxi.a);
			_matrixVector.push(matrxi.c);
			_matrixVector.push(0);
			_matrixVector.push(matrxi.tx);
			_matrixVector.push(matrxi.b);
			_matrixVector.push(matrxi.d);
			_matrixVector.push(0);
			_matrixVector.push(matrxi.ty);
			_matrixVector.push(1);
			return _matrixVector;
		}*/
		
		
	//	private  var matrxi:Matrix=new Matrix();
		/**得到转化后的矩阵  
		 */		
		public function getConvertMatrix(obj:GDisplayObject):Matrix3D
		{
			
			var matrxi:Matrix3D=new Matrix3D();
			//matrxi.identity();
			
			var currentObj:GDisplayObject=obj;
			while(currentObj)
			{
				matrxi.append(getObjMatrix(currentObj));
				currentObj=currentObj.parent;
			}
			return matrxi;
			
			//
		//	var _matrixVector:Vector.<Number>=new Vector.<Number>();
			////  a   c  0    tx         b d    ty   0
			//_matrixVector.push(matrxi.a,matrxi.c,0,matrxi.tx,matrxi.b,matrxi.d,0,matrxi.ty,1);
/*			_matrixVector.push(matrxi.c);
			_matrixVector.push(0);
			_matrixVector.push(matrxi.tx);
			_matrixVector.push(matrxi.b);
			_matrixVector.push(matrxi.d);
			_matrixVector.push(0);
			_matrixVector.push(matrxi.ty);
			_matrixVector.push(1);
*/			//return _matrixVector;
		}
		
	
		/*private function getObjMatrix2(obj:GDisplayObject):Matrix
		{
			var W:Number,H:Number;
			if(obj==obj.stage) return new Matrix();
			if(obj.parent==obj.stage)
			{
				W=this.W;
				H=this.H;
			}
			else 
			{
				var parentTmpRotation:Number=obj.parent.rotation;
				obj.parent.rotation=0;
				W=obj.parent.width;
				H=obj.parent.height;
				obj.parent.rotation=parentTmpRotation;
			}
			
			var matrxi:Matrix=new Matrix();
			var tmpRotation:Number=obj.rotation;
			obj.rotation=0;
			var objWidth:Number=obj.width;
			var objHeight:Number=obj.height;
			obj.rotation=tmpRotation;
			if(obj is GDisplayObjectContainer)
			{
				objWidth *=obj.scaleX;
				objHeight *=obj.scaleY;
			}
			var pivot_x:Number=(W*0.5-W*obj.pivotX/objWidth)*2/W;///百分比
			var pivot_y:Number=(H*obj.pivotY/objHeight-H*0.5)*2/H; ///百分比
			
			//	degree=0
			//matrxi.translate(1,-1); ///移动注册点///向右向下 移动注册点
			matrxi.translate(pivot_x,pivot_y); ///移动注册点
			matrxi.rotate(GMath.DegreeToRadian(-obj.rotation));  //旋转必须放在第一位
			matrxi.translate(-pivot_x,-pivot_y);   ///恢复移动前的状态
			matrxi.scale(objWidth/W,objHeight/H);
			//	matrxi.scale(-1,1)
			///设置坐标
			matrxi.translate((obj.x+objWidth*0.5-W*0.5)*2/W,-(obj.y+objHeight*0.5-H*0.5)*2/H);
			return matrxi;
		}*/
		
		
		private function getObjMatrix(obj:GDisplayObject):Matrix3D
		{
			var W:Number,H:Number;
			if(obj==obj.stage) return new Matrix3D();
			if(obj.parent==obj.stage)
			{
				W=this.W;
				H=this.H;
			}
			else 
			{
				var parentTmpRotation:Number=obj.parent.rotation;
				obj.parent.rotation=0;
				W=obj.parent.width;
				H=obj.parent.height;
				obj.parent.rotation=parentTmpRotation;
			}
			var tmpRotation:Number=obj.rotation;
			obj.rotation=0;
			var objWidth:Number=obj.width;
			var objHeight:Number=obj.height;
			obj.rotation=tmpRotation;
			if(obj is GDisplayObjectContainer)
			{
				objWidth *=obj.scaleX;
				objHeight *=obj.scaleY;
			}
			var pivot_x:Number=(W*0.5-W*obj.pivotX/objWidth)*2/W;///百分比
			var pivot_y:Number=(H*obj.pivotY/objHeight-H*0.5)*2/H; ///百分比
			
			//	degree=0
			//matrxi.translate(1,-1); ///移动注册点///向右向下 移动注册点
			var matrix:Matrix3D=new Matrix3D();
			matrix.appendTranslation(pivot_x,pivot_y, 0.0);
			matrix.appendRotation(-obj.rotation, Vector3D.Z_AXIS); //角度单位
			matrix.appendTranslation(-pivot_x, -pivot_y, 0.0);
			matrix.appendScale(objWidth/W,objHeight/H, 1.0);
			matrix.appendTranslation((obj.x+objWidth*0.5-W*0.5)*2/W,-(obj.y+objHeight*0.5-H*0.5)*2/H,0);
			return matrix;
		}
		
		
	}
}