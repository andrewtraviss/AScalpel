package com.andrewtraviss.ascalpel
{
	import com.bit101.components.Component;
	import com.bit101.components.HBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	public class LiveEditor extends VBox
	{
		override protected function onResize(event:Event):void
		{
			super.onResize(event);
			updateWindowSize();
		}
		
		private function createEditors():void
		{			
			createFieldsFor(_reflection..accessor);
			createFieldsFor(_reflection..variable);
			createButtonBar();
			updateWindowSize();
		}
		
		private function createFieldsFor(in_properties:XMLList):void
		{
			var editableTag:XMLList;
			for each(var property:XML in in_properties)
			{
				editableTag = property.metadata.(@name=="Editable");
				if(editableTag.length() > 0)
				{
					addEditorFor(property);
				}
			}
		}
		
		private function createButtonBar():void
		{
			_buttonBar = new HBox();
			addChild(_buttonBar);
			createCloseButton();
			createRefreshButton();
		}
		
		private function updateWindowSize():void
		{
			if(window)
			{
				window.setSize(width + 40, height + 40);
			}
		}
		
		private function addEditorFor(in_property:XML):void
		{
			startNextField();
			createLabelFor(in_property);
			var propertyEditor:PropertyEditor = createEditorFor(in_property);
			if(propertyEditor.explicitCommit)
			{
				createCommitButtonFor(propertyEditor);
			}
			_properties[_properties.length] = propertyEditor;
		}
		
		private function createCloseButton():void
		{
			_closeButton = new PushButton();
			_closeButton.label = "Close";
			_closeButton.addEventListener(MouseEvent.CLICK, handleClickedCloseButton);
			_buttonBar.addChild(_closeButton);
			_closeButton.draw();
		}
		
		private function createRefreshButton():void
		{
			_refreshButton = new PushButton();
			_refreshButton.label = "Refresh";
			_refreshButton.addEventListener(MouseEvent.CLICK, handleClickedRefreshButton);
			_buttonBar.addChild(_refreshButton);
			_refreshButton.draw();
		}
		
		private function handleClickedCloseButton(in_event:MouseEvent):void
		{
			AScalpel.instance.removeEditor(this);
		}
		
		private function handleClickedRefreshButton(in_event:MouseEvent):void
		{
			var editor:PropertyEditor;
			for(var i:int=0; i<_properties.length; i++)
			{
				editor = _properties[i];
				editor.refresh();
			}
		}
		
		private function startNextField():void
		{
			_currentEditorContainer = new HBox();
			addChild(_currentEditorContainer);
		}
		
		private function createLabelFor(in_property:XML):Label
		{
			var label:Label = new Label();
			label.autoSize = true;
			label.text = in_property.@name;
			_currentEditorContainer.addChild(label);
			return label;
		}
		
		private function createEditorFor(in_property:XML):PropertyEditor
		{
			var propertyEditor:PropertyEditor = PropertyEditorFactory.instance.fromXML(in_property);
			propertyEditor.targetProperty(_object, in_property.@name);
			_currentEditorContainer.addChild(propertyEditor.view);
			return propertyEditor;
		}
		
		private function createCommitButtonFor(in_editor:PropertyEditor):PushButton
		{
			var button:PushButton = new PushButton();
			button.label = "Commit";
			button.width = 60;
			in_editor.useCommitControl(button);
			in_editor.useCommitEvent(MouseEvent.CLICK);
			_currentEditorContainer.addChild(button);
			return button;
		}
		
		public function get value():*
		{
			return _object;
		}
		public function set value(in_value:*):void
		{
			_object = in_value;
			_reflection = describeType(_object);
			createEditors();
		}
		
		public function get display():DisplayObjectContainer
		{
			return this;
		}
		
		public var window:Window;
		private var _object:*;
		private var _reflection:XML;
		private var _properties:Array = [];
		private var _editors:Object = {};
		private var _currentEditorContainer:HBox;
		private var _buttonBar:HBox;
		private var _closeButton:PushButton;
		private var _refreshButton:PushButton;
	}
}