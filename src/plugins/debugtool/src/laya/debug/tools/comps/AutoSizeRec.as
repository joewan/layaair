package laya.debug.tools.comps
{

	
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.editor.comonents.DragBar;
	import laya.ui.Box;

	/**
	 * ...
	 * @author ww
	 */
	public class AutoSizeRec extends Sprite
	{
		public var type:int;
		public function AutoSizeRec(type:String) 
		{
			super(type);
		}
		
		override public function set height(value:Number):void
		{
			// TODO Auto Generated method stub
			super.height = value;
			changeSize();
		}
		
		override public function set width(value:Number):void
		{
			// TODO Auto Generated method stub
			super.width = value;
			changeSize();
		}
		
		private var _color:String = "#ffffff";
		public function setColor(color:String):void
		{
			_color = color;
			reRender();
		}
		
		protected function changeSize():void
		{
			// TODO Auto Generated method stub
			reRender();

		}
		private function reRender():void
		{
			var g:Graphics = graphics;
			g.clear();
			g.drawRect(0, 0, width, height, _color);
		}
		public var preX:Number;
		public var preY:Number;
		public function record():void
		{
			preX = x;
			preY = y;
		}
		public function getDx():Number
		{
			return x - preX;
		}
		public function getDy():Number
		{
			return y - preY;
		}
		
	}

}