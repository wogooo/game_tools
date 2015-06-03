package com.msg.chat {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.chat.Channels;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CSendChatMsg extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CHANNEL:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.chat.CSendChatMsg.channel", "channel", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.chat.Channels);

		public var channel:int;

		/**
		 *  @private
		 */
		public static const MSG:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.chat.CSendChatMsg.msg", "msg", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var msg:String;

		/**
		 *  @private
		 */
		public static const TO_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.CSendChatMsg.to_id", "toId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var to_id$field:int;

		private var hasField$0:uint = 0;

		public function clearToId():void {
			hasField$0 &= 0xfffffffe;
			to_id$field = new int();
		}

		public function get hasToId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set toId(value:int):void {
			hasField$0 |= 0x1;
			to_id$field = value;
		}

		public function get toId():int {
			return to_id$field;
		}

		/**
		 *  @private
		 */
		public static const SHOW_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.CSendChatMsg.show_pos", "showPos", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var show_pos$field:int;

		public function clearShowPos():void {
			hasField$0 &= 0xfffffffd;
			show_pos$field = new int();
		}

		public function get hasShowPos():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set showPos(value:int):void {
			hasField$0 |= 0x2;
			show_pos$field = value;
		}

		public function get showPos():int {
			return show_pos$field;
		}

		/**
		 *  @private
		 */
		public static const VERIFY:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.chat.CSendChatMsg.verify", "verify", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var verify$field:String;

		public function clearVerify():void {
			verify$field = null;
		}

		public function get hasVerify():Boolean {
			return verify$field != null;
		}

		public function set verify(value:String):void {
			verify$field = value;
		}

		public function get verify():String {
			return verify$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.channel);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.msg);
			if (hasToId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, to_id$field);
			}
			if (hasShowPos) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, show_pos$field);
			}
			if (hasVerify) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, verify$field);
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
			var to_id$count:uint = 0;
			var show_pos$count:uint = 0;
			var verify$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (channel$count != 0) {
						throw new flash.errors.IOError('Bad data format: CSendChatMsg.channel cannot be set twice.');
					}
					++channel$count;
					this.channel = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (msg$count != 0) {
						throw new flash.errors.IOError('Bad data format: CSendChatMsg.msg cannot be set twice.');
					}
					++msg$count;
					this.msg = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (to_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CSendChatMsg.toId cannot be set twice.');
					}
					++to_id$count;
					this.toId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (show_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CSendChatMsg.showPos cannot be set twice.');
					}
					++show_pos$count;
					this.showPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (verify$count != 0) {
						throw new flash.errors.IOError('Bad data format: CSendChatMsg.verify cannot be set twice.');
					}
					++verify$count;
					this.verify = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
