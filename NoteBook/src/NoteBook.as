package
{
	import com.notebook.module.noteView.NoteView;
	
	import flash.display.Sprite;
	
	public class NoteBook extends Sprite
	{
		public function NoteBook()
		{
			
			loading();
		}
		
		/**加载外部界面
		 */ 
		private function loading():void
		{
			
		}
		
		private function initUI():void
		{
			new NoteView(this);
		}
		
		
	}
}