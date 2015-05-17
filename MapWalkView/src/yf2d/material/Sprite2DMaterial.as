package yf2d.material
{
	/**@author yefeng
	 *20122012-11-17上午12:07:40
	 */
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	
	import yf2d.geom.Face2;
	
	public class Sprite2DMaterial extends AbsMaterial
	{
		public function Sprite2DMaterial(context3d:Context3D)
		{
			super(context3d);
		}
		
		override protected function initData():void
		{
			
//			var agalVertexSource:String = "m44 op, va0, vc0   \n" + // vertex * clipspace
//				"mov vt0, va1  \n" + // save uv in temp register
//				"mul vt0.xy, vt0.xy, vc4.zw   \n" + // mult with uv-scale
//				"add vt0.xy, vt0.xy, vc4.xy   \n" + // add uv offset
//				"mov v0, vt0 \n"; // copy uv
//			
//			var agalFragmentSource:String =
//				"tex ft0, v0, fs0 <TEXTURE_SAMPLING_OPTIONS>\n" + // sample texture from interpolated uv coords
//				"mul ft0, ft0, fc0\n" + // mult with colorMultiplier
//				"add oc, ft0, fc1\n"; // mult with colorOffset
			
			
			var agalVertexSource:String =
				"m44 op, va0, vc0            \n" + // vertex * clipspace[idx]         4 register
				"mov vt0, va1                \n" + // save uv in temp register
				"mul vt0.xy, vt0.xy, vc4.zw   \n" + // mult with uv-scale				1	register 
				"add vt0.xy, vt0.xy, vc4.xy   \n" + // add uv offset
				"mov v0, vt0                  \n" + // copy uv
				"mov v1, vc5	                \n"  // copy colorMultiplier[idx]			1	register 
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
			vertextBuff=context3d.createVertexBuffer(SpriteVertextNum,VertextData);
			vertextBuff.uploadFromVector(vertextArr,0,SpriteVertextNum);
			indexBuffer=context3d.createIndexBuffer(6);
			indexBuffer.uploadFromVector(indexArr,0,6);
			
			///设置va0  va1  
			context3d.setVertexBufferAt(0, vertextBuff, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
			context3d.setVertexBufferAt(1, vertextBuff, 2, Context3DVertexBufferFormat.FLOAT_2); // uv

			
			
		}
		
		
		override protected function createVertexData():void
		{
			
			indexArr=new Vector.<uint>();
			vertextArr=new Vector.<Number>();
			var face:Face2=new Face2();
			var vertextStr:String;
			var uvStr:String;
			var num:int;
			var perData:uint;
			for(var i:int=0;i!=SpriteVertextNum;++i)
			{
				num=i+1;
				vertextStr="vertex"+num;
				uvStr="uv"+num;
				vertextArr.push(face[vertextStr].x);
				vertextArr.push(face[vertextStr].y);
				vertextArr.push(face[uvStr].u);
				vertextArr.push(face[uvStr].v);
				vertextArr.push(0);							/// matrix_id
				vertextArr.push(4)	;								/// rbg_id  
				vertextArr.push(5);								///   uv_id 
			}
			indexArr.push(0,1,2,0,2,3);
		}
		
		


	}
}