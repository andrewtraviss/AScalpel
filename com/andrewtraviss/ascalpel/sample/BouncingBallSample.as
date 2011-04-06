/*
Copyright (C) 2011 by Andrew Traviss

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
*/
package com.andrewtraviss.ascalpel.sample
{
	import com.andrewtraviss.ascalpel.AScalpel;
	import com.andrewtraviss.ascalpel.StandardBit101Editors;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.Component;
	import com.bit101.components.NumericStepper;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	[SWF(width="600", height="450")]
	public class BouncingBallSample extends Sprite
	{
		public function BouncingBallSample()
		{
			_game = new Sprite();
			StandardBit101Editors.install();
			
			createView();
			createBall();
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		private function createView():void
		{
			addChild(_game);
			addChild(AScalpel.instance.display);
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
			
			if(_ball.y > 450 - _ball.radius)
			{
				_ball.y = 450 - _ball.radius;
				_ball.yVelocity = -_ball.yVelocity * 0.9;
			}
			if(_ball.x > 600 - _ball.radius)
			{
				_ball.x = 600 - _ball.radius;
				_ball.xVelocity = -_ball.xVelocity * 0.9;
			}
			
			_ball.redraw();
		}
		
		private function handleKeyDown(in_event:KeyboardEvent):void
		{
			if(in_event.keyCode == Keyboard.SPACE)
			{
				restart();
			}
		}
		
		private function restart():void
		{
			_game.removeChild(_ball.sprite);
			_ball = null;
			createBall();
		}
		
		private function createBall():void
		{
			_ball = new BouncingBall();
			_ball.name = "theBall";
			_ball.xVelocity = 1;
			_game.addChild(_ball.sprite);
			
			AScalpel.instance.open(_ball);
		}
		
		private var _ball:BouncingBall;
		private var _game:Sprite;
	}
}