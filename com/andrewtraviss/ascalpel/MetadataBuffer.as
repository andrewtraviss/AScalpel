package com.andrewtraviss.ascalpel
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	/**
	 * @private
	 */
	public class MetadataBuffer
	{
		public static function get instance():MetadataBuffer
		{
			if(!_instance)
			{
				_instance = new MetadataBuffer(new SingletonToken());
			}
			return _instance;
		}
		
		public function MetadataBuffer(TOKEN:SingletonToken)
		{
			
		}
		
		public function setMetadataFor(in_type:String, in_metadata:XML):void
		{
			_metadataByType[in_type] = in_metadata;
		}
		
		public function getMetadataForInstance(in_instance:*):XML
		{
			var className:String = getClassNameWithPackage(in_instance);
			return getMetadataForType(className);
		}
		
		public function getMetadataForType(in_type:String):XML
		{
			if(!_metadataByType[in_type])
			{
				var type:* = getDefinitionByName(in_type);
				_metadataByType[in_type] = describeType(type);
			}
			
			return _metadataByType[in_type];
		}
		
		private function getClassNameWithPackage(in_object:*):String
		{
			var reflection:XML = describeType(in_object);
			var name:String = reflection.@name;
			name = name.split("::").join(".");
			return name;
		}
		
		private var _metadataByType:Object = {};
		
		private static var _instance:MetadataBuffer;
	}
}

internal class SingletonToken
{
}