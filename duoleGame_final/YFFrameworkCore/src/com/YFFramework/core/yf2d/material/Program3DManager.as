package com.YFFramework.core.yf2d.material
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.utils.Dictionary;

	/**
	 * Program管理器 
	 * @author yefeng
	 * 2013 2013-10-31 下午3:37:03 
	 */
	public class Program3DManager
	{
		/**透明 atf   program   dx5   yo
		 */
		public static const ATFAlphaProgram:int=1;

		/** 非透明   atf  dx1   用于   背景 地图
		 */
		public static const ATFNoALphaProgram:int=2;

		private static var _dict:Dictionary=new Dictionary(); 
		
		/**上一次渲染 使用的Program 
		 */
		private static var _preRenderProgram:int=-1;
		private static var _context3d:Context3D;
		public function Program3DManager()
		{
		}
		
		/**设置program3D
		 */
		public static function setProgram(programId:int):void
		{
//			if(programId!=_preRenderProgram)
//			{
//				_context3d.setProgram(_dict[programId]);
//				_preRenderProgram=programId;
//			}
			//上面的 atf切换
			_context3d.setProgram(_dict[ATFAlphaProgram]);
		}
		
		
		/**初始化shader 
		 */
		public static function  initShader(context3d:Context3D):void
		{
			_context3d=context3d;
			
			var agalVertexSource:String =
				"m44 op, va0, vc0            \n" + // vertex * clipspace[idx]         4 register
				"mov vt0, va1                \n" + // save uv in temp register
				"mul vt0.xy, vt0.xy, vc4.zw   \n" + // mult with uv-scale				1	register 
				"add vt0.xy, vt0.xy, vc4.xy   \n" + // add uv offset
				"mov v0, vt0                  \n" + // copy uv
				"mov v1, vc5	                \n"  // copy colorMultiplier[idx]			1	register 
			//	"mov v2, vc[va2.z]	                \n"; // copy colorOffset[idx]
			var agalFragmentSourceDx5:String =
				//	"tex ft0, v0, fs0 <TEXTURE_SAMPLING_OPTIONS>  \n" + // sample texture from interpolated uv coords
				"tex ft0, v0, fs0 <2d,linear,mipnone,clamp,dxt5> \n" +
				"mul ft0, ft0, v1                    \n" + // mult with colorMultiplier
//				"mul ft0,ft0,ft0.wwww				\n	" +//"预乘alpha"  ///只针对纸娃娃系统  的 atf  ///其他 对象 不需要 
				"mov oc, ft0                         \n"; // 
			
			
			var agalFragmentSourceDX1:String =
				//	"tex ft0, v0, fs0 <TEXTURE_SAMPLING_OPTIONS>  \n" + // sample texture from interpolated uv coords
				"tex ft0, v0, fs0 <2d,linear,mipnone,clamp,dxt1> \n" +
				"mul ft0, ft0, v1                    \n" + // mult with colorMultiplier
//				"mul ft0,ft0,ft0.wwww				\n	" +//"预乘alpha"  ///只针对纸娃娃系统  的 atf  ///其他 对象 不需要 
				"mov oc, ft0                         \n"; // 
 
			
			
			
			var agalVertexDx5:AGALMiniAssembler=new AGALMiniAssembler(); 
			var agalFragmentDx5:AGALMiniAssembler=new AGALMiniAssembler();
			agalVertexDx5.assemble(Context3DProgramType.VERTEX, agalVertexSource);
			agalFragmentDx5.assemble(Context3DProgramType.FRAGMENT, agalFragmentSourceDx5);
			
			var dx5Program:Program3D=context3d.createProgram();
			dx5Program.upload(agalVertexDx5.agalcode,agalFragmentDx5.agalcode);
	//		context3d.setProgram(program);
			_dict[ATFAlphaProgram]=dx5Program;
			
			var agalVertexDx1:AGALMiniAssembler=new AGALMiniAssembler(); 
			var agalFragmentDx1:AGALMiniAssembler=new AGALMiniAssembler();
			agalVertexDx1.assemble(Context3DProgramType.VERTEX, agalVertexSource);
			agalFragmentDx1.assemble(Context3DProgramType.FRAGMENT, agalFragmentSourceDX1);
			
			var dx1Program:Program3D=context3d.createProgram();
			dx1Program.upload(agalVertexDx1.agalcode,agalFragmentDx1.agalcode);
			
			_dict[ATFNoALphaProgram]=dx1Program;

		}
		public static function getProgram(programId:int):Program3D
		{
			return _dict[programId];
		}
			
	}
}