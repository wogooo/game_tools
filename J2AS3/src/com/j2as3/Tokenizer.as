package com.j2as3 {
	internal class Tokenizer {
		private var string:String;
		private var pos:uint;
		
		private var keywords:Array = [
				"abstract",
				"boolean",
				"break",
				"byte",
				"case",
				"catch",
				"char",
				"class",
				"const",
				"continue",
				"default",
				"do",
				"double",
				"else",
				"extends",
				"false",
				"final",
				"finally",
				"float",
				"for",
				"goto",
				"if",
				"implements",
				"import",
				"instanceof",
				"int",
				"interface",
				"long",
				"native",
				"new",
				"null",
				"package",
				"private",
				"protected",
				"public",
				"return",
				"short",
				"static",
				"strictfp",
				"super",
				"switch",
				"synchronized",
				"this",
				"throw",
				"throws",
				"transient",
				"true",
				"try",
				"void",
				"volatile",
				"while"
			];
			
		private var symbols:Array = [
				"(",")",
				"{","}",
				"<",">",
				"<=",">=",
				"[","]",
				"*","*=",
				"instanceof",
				",",
				";",
				".",
				"~","~=",
				"=","==",
				"!","!=",
				"^","^=",
				"-","--",
				"+","++",
				"+=","-=",
				">>","<<","<<<",
				">>=","<<=","<<<=",
				"/","/=",
				"%","%=",
				":",
				"?",
				"&","&=","|",
				"&&","||"
			];
			
		
		public function Tokenizer(str:String) {
			this.string = str;
			pos = 0;
			
			symbols.sort(lengthSort);
			keywords.sort(lengthSort);
		}
		
		public function nextToken():Token {	
			if (pos>=string.length) 
			    return null;
			
			var c:String = string.charAt(pos);
			var token:Token;
			var start:uint = pos;
			var str:String;
			
			if (isWhitespace(c)) {
				skipWhitespace();
				c = currentChar();
				start = pos;
			}

			if (isNumber(c)) {
				skipToStringEnd();
				str = string.substring(start, pos);
				return new Token(str, Token.NUMBER, pos);
			}
			
			if (c=="/") {
				if (nextChar()=="*") {
					skipUntil("*/");
					return new Token(string.substring(start,pos), Token.COMMENT, pos);
				} else if (nextChar()=="/") {
					skipUntil("\n");
					pos--;
					return new Token(string.substring(start,pos), Token.COMMENT, pos);
				}
			}
			
			if (isLetter(c) || c=="$" || c=="_") {
				skipToStringEnd();				
				str = string.substring(start, pos);
				var type:String = Token.STRING_LITERAL;
				if (isKeyword(str)) 
				    type=Token.KEYWORD;
				return new Token(str, type, pos);
			} else if ((str=isSymbol(pos))!=null) {
				pos += str.length;
				return new Token(str, Token.SYMBOL, pos);
			} else if(c=="\"") {	// a string
				skipUntilWithEsc("\"");
				return new Token(string.substring(start, pos), Token.STRING, pos);
			} else if (c=="'") { // a char
				skipUntil("'");
				return new Token(string.substring(start,pos), Token.CHAR, pos);
			}			
			return null;
		}
		
		private function currentChar():String {
			return string.charAt(pos);
		}
		
		private function nextChar():String {
			if (pos>=string.length-1) 
			   return null;
			return string.charAt(pos+1);
		}
		
		private function skipUntil(exit:String):void {
			pos++;
			var p:uint = string.indexOf(exit, pos);
			if (p!=-1)
				pos = p + exit.length;
		}
		
        /** Patch from http://www.physicsdev.com/blog/?p=14#comments - thanks */	       
		private function skipUntilWithEsc(exit:String):void {
            pos++;
            var c:String;
            while ((c=string.charAt(pos)) != exit) {
                if (c == "\\") 
                    pos++;
                pos++;
            }
            pos++;		    
		}
		
		private function skipWhitespace():void {
			var c:String;
			c = currentChar();
			while (isWhitespace(c)) {
				pos++;
				c = currentChar();
			}
		}
		
		private function isWhitespace(str:String):Boolean {
			return str==" " || str=="\n" || str=="\t" || str=="\r";
		}
		
		private function skipToStringEnd():void {
			var c:String;
			while (true) {
				c = currentChar();
				if (isLetter(c) || isNumber(c) || c=="." || c=="$" || c=="_") {
				} else {
					break;
				}
				pos++;
				c = currentChar();
			}
		}
		
		private function isNumber(str:String):Boolean {
			var code:uint = str.charCodeAt(0);
			return (code>=48 && code<=57);
		}
		
		private function isLetter(str:String):Boolean {
			var code:uint = str.charCodeAt(0);
			if (code>=65 && code<=90) 
			    return true;
			if (code>=97 && code<=122) 
			    return true;
			return false;
		}
		
		private function isKeyword(str:String):Boolean {
			return inArray(keywords, str);
		}
		
		private function isSymbol(pos:uint):String {
			var s:String;
			for (var i:int=0; i<symbols.length; i++) {
				s = symbols[i];
				if (string.substr(pos,s.length)==s) 
				    return s;
			}
			return null;
		}
		
		private function inArray(arr:Array,item:Object):Boolean {
			for(var i:int=0; i<arr.length; i++)
				if (arr[i]==item) 
				    return true;
			return false;
		}
		
		private function lengthSort(strA:String,strB:String):int {
			if (strA.length<strB.length) 
			    return 1;
			if (strA.length>strB.length) 
			    return -1;
			return 0;
		}
		
		public function getAllTokens():Array{
			var arr:Array = [];
			pos = 0;
			var t:Token;
			while ((t = nextToken())!=null)
				arr.push(t);
			return arr;
		}
	}
}