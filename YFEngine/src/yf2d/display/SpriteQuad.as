package yf2d.display
{
	import flash.display3D.textures.Texture;
	
	import yf2d.textures.face.ITextureBase;
	
	/*
	 * author :夜枫
	 */
	public class SpriteQuad extends SpriteBatch
	{
		/**注册点pivotX在左上角 也就是(-width*0.5,-height*0.5)的位置
		 */		
		protected var image:Image;
		protected var viewWidth:Number;
		protected var viewHeight:Number;
		protected var imageTexture:ITextureBase;
		/**
		 * @param texture flashTexture对象
		 *   yfTexture 是和 texture像素源相关联的对象   texture像素源包含 yfTexture的像素
		 */
		public function SpriteQuad(texture:Texture,viewWidth:Number,viewHeight:Number)
		{
			super(texture);
			this.viewWidth=viewWidth;
			this.viewHeight=viewHeight;
			image=new Image();
			this.addChild(image);
		}
		/**	@param imageTexture   yf2d.textures包里的texture对象
		 * 设置 图片贴图材质    初始化该类后 必须调用该方法才能显示对象
		 */		
		public function setImageTexture(imageTexture:ITextureBase):void
		{
			this.imageTexture=imageTexture
			image.texture=imageTexture;
			////设置注册点在左上角
			image.pivotX=-image._width*0.5;
			image.pivotY=-image._height*0.5
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			image.dispose(childrenDispose);
			image=null;
			imageTexture=null;
		}
	}
}