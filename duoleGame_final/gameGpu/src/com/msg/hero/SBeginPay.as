package com.msg.hero {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SBeginPay extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RET:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SBeginPay.ret", "ret", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var ret:int;

		/**
		 *  @private
		 */
		public static const TOKEN:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.hero.SBeginPay.token", "token", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var token$field:String;

		public function clearToken():void {
			token$field = null;
		}

		public function get hasToken():Boolean {
			return token$field != null;
		}

		public function set token(value:String):void {
			token$field = value;
		}

		public function get token():String {
			return token$field;
		}

		/**
		 *  @private
		 */
		public static const URL_PARAMS:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.hero.SBeginPay.url_params", "urlParams", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var url_params$field:String;

		public function clearUrlParams():void {
			url_params$field = null;
		}

		public function get hasUrlParams():Boolean {
			return url_params$field != null;
		}

		public function set urlParams(value:String):void {
			url_params$field = value;
		}

		public function get urlParams():String {
			return url_params$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.ret);
			if (hasToken) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, token$field);
			}
			if (hasUrlParams) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, url_params$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var ret$count:uint = 0;
			var token$count:uint = 0;
			var url_params$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (ret$count != 0) {
						throw new flash.errors.IOError('Bad data format: SBeginPay.ret cannot be set twice.');
					}
					++ret$count;
					this.ret = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (token$count != 0) {
						throw new flash.errors.IOError('Bad data format: SBeginPay.token cannot be set twice.');
					}
					++token$count;
					this.token = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (url_params$count != 0) {
						throw new flash.errors.IOError('Bad data format: SBeginPay.urlParams cannot be set twice.');
					}
					++url_params$count;
					this.urlParams = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
