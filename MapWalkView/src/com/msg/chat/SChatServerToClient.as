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
	public dynamic final class SChatServerToClient extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CHANNEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.SChatServerToClient.channel", "channel", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var channel:int;

		/**
		 *  @private
		 */
		public static const MSG:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.chat.SChatServerToClient.msg", "msg", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var msg:String;

		/**
		 *  @private
		 */
		public static const FROM_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.chat.SChatServerToClient.from_name", "fromName", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var from_name$field:String;

		public function clearFromName():void {
			from_name$field = null;
		}

		public function get hasFromName():Boolean {
			return from_name$field != null;
		}

		public function set fromName(value:String):void {
			from_name$field = value;
		}

		public function get fromName():String {
			return from_name$field;
		}

		/**
		 *  @private
		 */
		public static const FROM_SERVER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.SChatServerToClient.from_server", "fromServer", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var from_server$field:int;

		private var hasField$0:uint = 0;

		public function clearFromServer():void {
			hasField$0 &= 0xfffffffe;
			from_server$field = new int();
		}

		public function get hasFromServer():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set fromServer(value:int):void {
			hasField$0 |= 0x1;
			from_server$field = value;
		}

		public function get fromServer():int {
			return from_server$field;
		}

		/**
		 *  @private
		 */
		public static const FROM_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.SChatServerToClient.from_id", "fromId", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var from_id$field:int;

		public function clearFromId():void {
			hasField$0 &= 0xfffffffd;
			from_id$field = new int();
		}

		public function get hasFromId():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set fromId(value:int):void {
			hasField$0 |= 0x2;
			from_id$field = value;
		}

		public function get fromId():int {
			return from_id$field;
		}

		/**
		 *  @private
		 */
		public static const TARGET_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.chat.SChatServerToClient.target_name", "targetName", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var target_name$field:String;

		public function clearTargetName():void {
			target_name$field = null;
		}

		public function get hasTargetName():Boolean {
			return target_name$field != null;
		}

		public function set targetName(value:String):void {
			target_name$field = value;
		}

		public function get targetName():String {
			return target_name$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.channel);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.msg);
			if (hasFromName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, from_name$field);
			}
			if (hasFromServer) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, from_server$field);
			}
			if (hasFromId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, from_id$field);
			}
			if (hasTargetName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, target_name$field);
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
			var from_name$count:uint = 0;
			var from_server$count:uint = 0;
			var from_id$count:uint = 0;
			var target_name$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (channel$count != 0) {
						throw new flash.errors.IOError('Bad data format: SChatServerToClient.channel cannot be set twice.');
					}
					++channel$count;
					this.channel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (msg$count != 0) {
						throw new flash.errors.IOError('Bad data format: SChatServerToClient.msg cannot be set twice.');
					}
					++msg$count;
					this.msg = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (from_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SChatServerToClient.fromName cannot be set twice.');
					}
					++from_name$count;
					this.fromName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (from_server$count != 0) {
						throw new flash.errors.IOError('Bad data format: SChatServerToClient.fromServer cannot be set twice.');
					}
					++from_server$count;
					this.fromServer = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (from_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SChatServerToClient.fromId cannot be set twice.');
					}
					++from_id$count;
					this.fromId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (target_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SChatServerToClient.targetName cannot be set twice.');
					}
					++target_name$count;
					this.targetName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
