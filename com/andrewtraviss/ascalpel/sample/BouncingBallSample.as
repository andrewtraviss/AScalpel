package com.andrewtraviss.ascalpel.sample
{
	import com.andrewtraviss.ascalpel.AScalpel;
	import com.andrewtraviss.ascalpel.StandardBit101Editors;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.Component;
	import com.bit101.components.NumericStepper;
	
	import flash.display.Sprite;
	import flash.events.Event;

	[SWF(width="800", height="600")]
	public class BouncingBallSample extends Sprite
	{
		public function BouncingBallSample()
		{
			_game = new Sprite();
			StandardBit101Editors.install();
			
			createView();
			createBall();
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		private function createView():void
		{
			addChild(_game);
			addChild(AScalpel.instance.display);
		}
		
		private function createBall():void
		{
			_ball = new BouncingBall();
			_ball.xVelocity = 1;
			_game.addChild(_ball.sprite);
			
			AScalpel.instance.addObject(_ball);
		}
		
		private function handleEnterFrame(in_event:Event):void
		{
			_ball.yVelocity += 0.1;
			
			_ball.x += _ball.xVelocity;
			_ball.y += _ball.yVelocity;
			
			if(_ball.y < _ball.radius)
			{
				_ball.y = _ball.radius;
				_ball.yVelocity = -_ball.yVelocity * 0.9;
			}
			if(_ball.x < _ball.radius)
			{
				_ball.x = _ball.radius;
				_ball.xVelocity = -_ball.xVelocity * 0.9;
			}
			
			if(_ball.y > 600 - _ball.radius)
			{
				_ball.y = 600 - _ball.radius;
				_ball.yVelocity = -_ball.yVelocity * 0.9;
			}
			if(_ball.x > 800 - _ball.radius)
			{
				_ball.x = 800 - _ball.radius;
				_ball.xVelocity = -_ball.xVelocity * 0.9;
			}
			
			_ball.redraw();
		}
		
		private var _ball:BouncingBall;
		private var _game:Sprite;
	}
}