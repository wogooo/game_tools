package com.j2as3 {
	import mx.utils.StringUtil;
	
	internal class Converter {
		private var str:String;
		private var tokenizer:Tokenizer;
		private var inFNDef:Boolean, inConstructor:Boolean;
		private var cFNName:String,cFNType:String;
		private var post:String;
		
		public function Converter(str:String){
			this.str = str;
			tokenizer = new Tokenizer(str);
		}
		
		public function getNewClass():String {
			var tokens:Array = tokenizer.getAllTokens();
			var str:String = "";
			var orig:String = this.str;
			var temp:String;
			var lastPos:uint = 0;	
			var newPos:uint;	
			var used:Boolean;
			var t:Token;
			
			post = "";
			
			for (var i:int=0; i<tokens.length; i++) {
				t=tokens[i];
				used = false;
				if (i<tokens.length-3) {
					if (isIdentifier(tokens[i]) && 
					    tokens[i+1].type==Token.STRING_LITERAL && 
					    (tokens[i+2].string=="=" || tokens[i+2].string==";" || tokens[i+2].string=="," || tokens[i+2]==")")) {
						var varName:String = tokens[i+1];
						var varType:String = toASType(tokens[i]);
						
						if(inFNDef|| inConstructor)
							str+=varName + ":" + varType;
						else
							str+="var " + varName + ":" + varType
						
						i += 1;
						used = true;
					} else if (isIdentifier(tokens[i]) && 
					           tokens[i+1].type==Token.STRING_LITERAL && 
					           tokens[i+2]=="(") { //Function definition
						inFNDef = true;
						cFNName = tokens[i+1];
						cFNType = toASType(tokens[i]);
						
						str += "function " + cFNName;
						used = true;
						i+=1;
					}
				}
				
				if (i<tokens.length-3) {	//Constructor definition
					if (isPPP(tokens[i]) && isIdentifier(tokens[i+1]) && tokens[i+2]=="("){
						inConstructor = true;
						used = true;
						str += tokens[i] + " function " + tokens[i+1];
						i++;
					}
				}
				
				if (i<tokens.length-3) {
					if (tokens[i]=="package" && tokens[i+1].type==Token.STRING_LITERAL && tokens[i+2]==";") {
						str += tokens[i] + " " + tokens[i+1] + "\n{\n";
						used = true;
						i += 2;
						post += "\n}";
					}
				}
				
				if (i<tokens.length-3) {
					if (tokens[i]=="(" && isIdentifier(tokens[i+1]) && tokens[i+2]==")"){
						if (tokens[i-1].type!=Token.STRING_LITERAL && tokens[i-1].type!=Token.KEYWORD) {
							var castType:String = tokens[i+1];
							i += 3;
							var n:String;
							var inside:uint = 0;
							var sss:String;
							var start:uint = i;
							sss = "";
							while (true) {
								n = tokens[i];
								if (n=="(" || n=="[" || n=="{") {
									inside++;
									sss += n;
								}

								if (inside>0) {
									if (n==")" || n=="]" || n=="}") {
										if (inside>0) 
										  inside--;
										sss += n;
									}
								} else {
									if (tokens[i].type==Token.SYMBOL && n!=".") {
										i--;
										break;
									}
								}
								i++;
							}
							sss = orig.substring(tokens[start].pos,tokens[i+1].pos);
							str += castType + "(" + sss + ")";
							used = true;
						}
					}
				}
				
				if (i<tokens.length-5) {
					if (isIdentifier(tokens[i]) && 
					    tokens[i+1]=="[" && tokens[i+2]=="]" && 
					    tokens[i+3].type==Token.STRING_LITERAL && 
					    (tokens[i+4].string=="=" || tokens[i+4].string==";" || tokens[i+4].string=="," || tokens[i+4]==")")) { //array
						varName = tokens[i+3];
						varType = "Array";
						if (inFNDef|| inConstructor)
							str += varName + ":" + varType;
						else
							str+="var " + varName + ":" + varType;
						i += 3;
						used = true;
					}
				}
				if (t.string==")") {
					if (inFNDef) {
						inFNDef = false;
						used=true;
						str += "):" + cFNType;
					} else if (inConstructor) {
						inConstructor = false;
					}
				}
				if (t.type==Token.NUMBER) { // clean it up
					str += cleanNumber(t.string);
					used = true;
				}
				if (t.type==Token.COMMENT) {
					//used = true
				}
				t = tokens[i];
				newPos = t.pos + t.string.length;
				if (i<tokens.length-1)
					newPos=tokens[i+1].pos;
				if (!used) {
					temp = orig.substring(lastPos, newPos);
					str += temp;
				}
				lastPos = newPos;
			}
			return str + post;
		}
		
		private function isIdentifier(token:Token):Boolean {
			return isPrimitiveType(token.string) || token.type==Token.STRING_LITERAL
		}
		
		private function isPrimitiveType(str:String):Boolean {
			return str=="int" || str=="byte" || str=="double" || str=="boolean" || 
			       str=="float" || str=="void" || str=="char" || str=="short" || str=="long";
		}
		
		private function isPPP(str:String):Boolean {
			return str=="public" || str=="private" || str=="protected";
		}
		
		private function toASType(type:String):String {
			if (type=="double" || type=="float" || type=="Double")	
			    return "Number";
			if (type=="boolean") 
			    return "Boolean";
			if (type=="byte") 
			    return "uint";
			if (type=="long" || type=="short") 
			    return "Number";
			if (type=="char") 
			    return "String";
			return type;
		}
		
		private function cleanNumber(str:String):String{
			while(str.search("f")>-1)
				str = str.replace("f", "");
			return str;
		}
		
		private function replace(str:String, start:uint, end:uint, rep:String):String {
			return str.substring(0,start) + rep + str.substring(end,str.length);
		}
	}
}