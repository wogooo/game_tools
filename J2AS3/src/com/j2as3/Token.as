package com.j2as3 {
	internal class Token {
		public static const STRING_LITERAL:String = "string literal";
		public static const SYMBOL:String = "symbol";
		public static const STRING:String = "string";
		public static const CHAR:String = "char";
		public static const NUMBER:String = "number";
		public static const KEYWORD:String = "keyword";
		public static const COMMENT:String = "comment";
		
		public var string:String, type:String, pos:uint;
		
		
		public function Token(string:String, type:String, endPos:uint) {
			this.string = string;
			this.type = type;
			this.pos = endPos - string.length;
		}
		
		public function toString():String {
			return string;
		}
	}
}