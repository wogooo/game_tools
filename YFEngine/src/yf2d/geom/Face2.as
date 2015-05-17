package yf2d.geom
{
	/**
	 * author :夜枫
	 * 时间 ：2011-11-25 上午09:59:55
	 * 
	 * 两个三角面组成的矩形面
	 */
	public class Face2
	{
		public var vertex1:Vertex;
		public var uv1:UV;
		
		public var vertex2:Vertex;
		public var uv2:UV;

		public var vertex3:Vertex;
		public var uv3:UV;

		public var vertex4:Vertex;
		public var uv4:UV;

		
		
		/**    
		 *  flashX flashY 是在屏幕上的坐标(flash坐标系下的坐标)     textureX  textureY指的是该贴图在贴图源中的左上角的坐标  _width _height指的是贴图大小
		 */
		public function Face2()
		{
			
/*				-1.0, 1.0, 0.0, 1.0,                          	[0, 1, 2,0,2,3])
				-1.0,-1.0, 0.0, 0.0,
				1.0,-1.0, 1.0, 0.0,
				1.0, 1.0, 1.0, 1.0
*/
			vertex1=new Vertex(-1,1);
			vertex2=new Vertex(-1,-1);
			vertex3=new Vertex(1,-1);
			vertex4=new Vertex(1,1);
			uv1=new UV(0,1);
			uv2=new UV(0,0);
			uv3=new UV(1,0);
			uv4=new UV(1,1);
		}
		
		
		
		/** textureX  textureY指的是该贴图在贴图源中的左上角的坐标 , _width _height指的是该贴图的显示大小         所有的贴图最终都会copy到一张 BitmapData上   每一张得贴图都有相应的坐标位置
		 */		
		/*public function updateUV(textureX:Number,textureY:Number,_width:Number, _height:Number):void
		{
			var sourceTextureW:Number=Gpu2dProxy.Instance.textureRect.width;
			var sourceTextureH:Number=Gpu2dProxy.Instance.textureRect.height;
			uv1.u=textureX/sourceTextureW;
			uv1.v=textureY/sourceTextureH;
			uv2.u=uv1.u;
			uv2.v=(textureY+_height)/sourceTextureH;
			uv3.u=(textureX+_width)/sourceTextureW;
			uv3.v=uv2.v;
			uv4.u=uv3.u;
			uv4.v=uv1.v;
		}
		
		
		
		
		public function nomalizeVertex():void
		{
			vertex1.x=-1;
			vertex1.y=1;
			vertex2.x=-1;
			vertex2.y=-1;
			vertex3.x=1;
			vertex3.y=-1;
			vertex4.x=1;
			vertex4.y=1;
		}
		
		public function nomalizeUV():void
		{
			uv1.u=0;
			uv1.v=0;
			uv2.u=0;
			uv2.v=1;
			uv3.u=1;
			uv3.v=1;
			uv4.u=1;
			uv4.v=0;
		}*/
		
	}
}