package com.andrewtraviss.ascalpel.sample
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	public class BouncingBall
	{
		public function BouncingBall()
		{
			_sprite = new Sprite();
			redraw();
		}
		
		public function redraw():void
		{
			_sprite.graphics.clear();
			_sprite.graphics.beginFill(_color);
			_sprite.graphics.drawCircle(_x,_y,_radius);
			_sprite.graphics.endFill();
		}
		
		[Editable(editorClass="com.bit101.components.NumericStepper", minimum="1", maximum="30", step="0.1")]
		public function get radius():Number
		{
			return _radius;
		}
		public function set radius(in_value:Number):void
		{
			_radius = in_value;
			redraw();
		}
		
		[Editable(editorClass="com.bit101.components.ColorChooser")]
		public function get color():uint
		{
			return _color;
		}
		public function set color(in_value:uint):void
		{
			_color = in_value;
			redraw();
		}
		
		[Editable(explicitCommit="true")]
		public function get x():Number
		{
			return _x;
		}
		public function set x(in_value:Number):void
		{
			_x = in_value;
		}
		
		[Editable(explicitCommit="true")]
		public function get y():Number
		{
			return _y;
		}
		public function set y(in_value:Number):void
		{
			_y = in_value;
		}
		
		[Editable(explicitCommit="true")]
		public function get xVelocity():Number
		{
			return _xVelocity;
		}
		public function set xVelocity(in_value:Number):void
		{
			_xVelocity = in_value;
		}
		
		[Editable(explicitCommit="true")]
		public function get yVelocity():Number
		{
			return _yVelocity;
		}
		public function set yVelocity(in_value:Number):void
		{
			_yVelocity = in_value;
		}
		
		public function get sprite():DisplayObject
		{
			return _sprite;
		}
		
		private var _radius:Number = 1;
		private var _color:uint = 0x000000;
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _xVelocity:Number = 0;
		private var _yVelocity:Number = 0;
		private var _sprite:Sprite;
	}
}