package com.msg.chat {
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
	public dynamic final class CChatClientToServer extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CHANNEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.CChatClientToServer.channel", "channel", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var channel:int;

		/**
		 *  @private
		 */
		public static const MSG:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.chat.CChatClientToServer.msg", "msg", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var msg:String;

		/**
		 *  @private
		 */
		public static const FROM_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.CChatClientToServer.from_id", "fromId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var fromId:int;

		/**
		 *  @private
		 */
		public static const TO_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.chat.CChatClientToServer.to_name", "toName", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var to_name$field:String;

		public function clearToName():void {
			to_name$field = null;
		}

		public function get hasToName():Boolean {
			return to_name$field != null;
		}

		public function set toName(value:String):void {
			to_name$field = value;
		}

		public function get toName():String {
			return to_name$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.channel);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.msg);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.fromId);
			if (hasToName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, to_name$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var channel$count:uint = 0;
			var msg$count:uint = 0;
			var from_id$count:uint = 0;
			var to_name$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (channel$count != 0) {
						throw new flash.errors.IOError('Bad data format: CChatClientToServer.channel cannot be set twice.');
					}
					++channel$count;
					this.channel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (msg$count != 0) {
						throw new flash.errors.IOError('Bad data format: CChatClientToServer.msg cannot be set twice.');
					}
					++msg$count;
					this.msg = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (from_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CChatClientToServer.fromId cannot be set twice.');
					}
					++from_id$count;
					this.fromId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (to_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: CChatClientToServer.toName cannot be set twice.');
					}
					++to_name$count;
					this.toName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
