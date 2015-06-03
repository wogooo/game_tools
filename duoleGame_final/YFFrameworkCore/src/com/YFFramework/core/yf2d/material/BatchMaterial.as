package com.YFFramework.core.yf2d.material
{
	import com.YFFramework.core.yf2d.geom.Face2;
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-28 上午09:47:47
	 */
	public final class BatchMaterial extends AbsMaterial
	{
		//总共只有 128个 register<vc量>可以用  一个 矩阵mp44占四个register<vc量>   其他的vc量 占一个register  故下面的 占用的vc 为  4+ 1+1+1    //矩阵vc[va2.x] 占4个   uv 个  color 一个 

		public static  const ConstantsPerSprite:uint = 6; // matrix, colorMultiplier, , uvoffset  4 + 1  +  1
		public static const ConstantPerMatrix:uint=4;  /// 1个矩阵占有  4个  register 
	//	public static  const ConstantsPerMatrix:uint = 4;
		public static  const BatchSize:uint= 126/ConstantsPerSprite	;	// 128/ConstantsPerSprite取整数
		
		/// va2中的 id     x  y  z         矩阵id   颜色id   uv id 
	//	public static const TransformId:uint=0;//矩阵id 
	//	public static const ColorId:uint=1;//颜色id 
	//	public static const UVId:uint=2; ///uv id 
		
		private var program:Program3D;
		public function BatchMaterial(context3d:Context3D)
		{
			super(context3d);
		}
		override protected function initData():void
		{
			   //总共只有 128个 register<vc量>可以用  一个 矩阵mp44占四个register<vc量>   其他的vc量 占一个register  故下面的 占用的vc 为  4+ 1+1+1    //矩阵vc[va2.x] 占4个   uv 个  color 一个 
			////`	va0       vt0/va1                         va2
			 ///  x   y     u   v          Matix_ID    rbgColor_ID     uv_Id 
			 var agalVertexSource:String =
				 "m44 op, va0, vc[va2.x]            \n" + // vertex * clipspace[idx]         4 register
				 "mov vt0, va1                \n" + // save uv in temp register
				"mul vt0.xy, vt0.xy, vc[va2.z].zw   \n" + // mult with uv-scale				1	register 
				"add vt0.xy, vt0.xy, vc[va2.z].xy   \n" + // add uv offset
				"mov v0, vt0                  \n" + // copy uv
				"mov v1, vc[va2.y]	                \n"  // copy colorMultiplier[idx]			1	register 
			//	"mov v2, vc[va2.z]	                \n"; // copy colorOffset[idx]
			 var agalFragmentSource:String =
				"tex ft0, v0, fs0 <TEXTURE_SAMPLING_OPTIONS>  \n" + // sample texture from interpolated uv coords
				"mul ft0, ft0, v1                    \n" + // mult with colorMultiplier
				"mov oc, ft0                         \n"; // 
			
			var agalVertex:AGALMiniAssembler=new AGALMiniAssembler(); 
			var agalFragment:AGALMiniAssembler=new AGALMiniAssembler();
			agalVertex.assemble(Context3DProgramType.VERTEX, agalVertexSource);
			agalFragment.assemble(Context3DProgramType.FRAGMENT, agalFragmentSource);
			program=context3d.createProgram();

			program.upload(agalVertex.agalcode,agalFragment.agalcode);
			context3d.setProgram(program);    
			///创建buff
			vertextBuff=context3d.createVertexBuffer(BatchSize*SpriteVertextNum,VertextData);
			vertextBuff.uploadFromVector(vertextArr,0,BatchSize*SpriteVertextNum);
			indexBuffer=context3d.createIndexBuffer(BatchSize*6);
			indexBuffer.uploadFromVector(indexArr,0,BatchSize*6);
			
			///设置va0  va1  va2 
			context3d.setVertexBufferAt(0,vertextBuff,0,Context3DVertexBufferFormat.FLOAT_2);
			context3d.setVertexBufferAt(1,vertextBuff,2,Context3DVertexBufferFormat.FLOAT_2);
			context3d.setVertexBufferAt(2,vertextBuff,4,Context3DVertexBufferFormat.FLOAT_3);

			
			
		}
		
		/** 创建点点的数据      x  y   u   v      //   矩阵id  颜色id  uv id 已经默认为012 这里可以不需要写上去
		 */		
		override protected function createVertexData():void
		{
			indexArr=new Vector.<uint>();
			vertextArr=new Vector.<Number>();
			var face:Face2=new Face2();
			var vertextStr:String;
			var uvStr:String;
			var num:int;
			var perData:uint;
			for(var j:int=0;j!=BatchSize;++j)
			{
				for(var i:int=0;i!=SpriteVertextNum;++i)
				{
					num=i+1;
					vertextStr="vertex"+num;
					uvStr="uv"+num;
					vertextArr.push(face[vertextStr].x);
					vertextArr.push(face[vertextStr].y);
					vertextArr.push(face[uvStr].u);
					vertextArr.push(face[uvStr].v);
					vertextArr.push(ConstantsPerSprite*j);							/// matrix_id
					vertextArr.push(ConstantsPerSprite*j+ConstantPerMatrix)	;								/// rbg_id  
					vertextArr.push(ConstantsPerSprite*j+ConstantPerMatrix+1);								///   uv_id 
				}
				//// [0 1 2   0 2 3]
				perData=SpriteVertextNum*j;
				indexArr.push(perData+0,perData+1,perData+2,perData+0,perData+2,perData+3);
			}
		}
		
	
		
	}
}