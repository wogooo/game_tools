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
	public dynamic final class SForwardChatMsg extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CHANNEL:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.chat.SForwardChatMsg.channel", "channel", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.chat.Channels);

		public var channel:int;

		/**
		 *  @private
		 */
		public static const MSG:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.chat.SForwardChatMsg.msg", "msg", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var msg:String;

		/**
		 *  @private
		 */
		public static const FROM_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.SForwardChatMsg.from_id", "fromId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var from_id$field:int;

		private var hasField$0:uint = 0;

		public function clearFromId():void {
			hasField$0 &= 0xfffffffe;
			from_id$field = new int();
		}

		public function get hasFromId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set fromId(value:int):void {
			hasField$0 |= 0x1;
			from_id$field = value;
		}

		public function get fromId():int {
			return from_id$field;
		}

		/**
		 *  @private
		 */
		public static const FROM_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.chat.SForwardChatMsg.from_name", "fromName", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

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
		public static const FROM_GENDER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.SForwardChatMsg.from_gender", "fromGender", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var from_gender$field:int;

		public function clearFromGender():void {
			hasField$0 &= 0xfffffffd;
			from_gender$field = new int();
		}

		public function get hasFromGender():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set fromGender(value:int):void {
			hasField$0 |= 0x2;
			from_gender$field = value;
		}

		public function get fromGender():int {
			return from_gender$field;
		}

		/**
		 *  @private
		 */
		public static const FROM_VIP_LV:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.SForwardChatMsg.from_vip_lv", "fromVipLv", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var from_vip_lv$field:int;

		public function clearFromVipLv():void {
			hasField$0 &= 0xfffffffb;
			from_vip_lv$field = new int();
		}

		public function get hasFromVipLv():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set fromVipLv(value:int):void {
			hasField$0 |= 0x4;
			from_vip_lv$field = value;
		}

		public function get fromVipLv():int {
			return from_vip_lv$field;
		}

		/**
		 *  @private
		 */
		public static const FROM_SERVER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.SForwardChatMsg.from_server", "fromServer", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var from_server$field:int;

		public function clearFromServer():void {
			hasField$0 &= 0xfffffff7;
			from_server$field = new int();
		}

		public function get hasFromServer():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set fromServer(value:int):void {
			hasField$0 |= 0x8;
			from_server$field = value;
		}

		public function get fromServer():int {
			return from_server$field;
		}

		/**
		 *  @private
		 */
		public static const SHOW_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.SForwardChatMsg.show_pos", "showPos", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var show_pos$field:int;

		public function clearShowPos():void {
			hasField$0 &= 0xffffffef;
			show_pos$field = new int();
		}

		public function get hasShowPos():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set showPos(value:int):void {
			hasField$0 |= 0x10;
			show_pos$field = value;
		}

		public function get showPos():int {
			return show_pos$field;
		}

		/**
		 *  @private
		 */
		public static const FROM_CAREER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.SForwardChatMsg.from_career", "fromCareer", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var from_career$field:int;

		public function clearFromCareer():void {
			hasField$0 &= 0xffffffdf;
			from_career$field = new int();
		}

		public function get hasFromCareer():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set fromCareer(value:int):void {
			hasField$0 |= 0x20;
			from_career$field = value;
		}

		public function get fromCareer():int {
			return from_career$field;
		}

		/**
		 *  @private
		 */
		public static const FROM_VIP_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.SForwardChatMsg.from_vip_type", "fromVipType", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var from_vip_type$field:int;

		public function clearFromVipType():void {
			hasField$0 &= 0xffffffbf;
			from_vip_type$field = new int();
		}

		public function get hasFromVipType():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set fromVipType(value:int):void {
			hasField$0 |= 0x40;
			from_vip_type$field = value;
		}

		public function get fromVipType():int {
			return from_vip_type$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.channel);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.msg);
			if (hasFromId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, from_id$field);
			}
			if (hasFromName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, from_name$field);
			}
			if (hasFromGender) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, from_gender$field);
			}
			if (hasFromVipLv) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, from_vip_lv$field);
			}
			if (hasFromServer) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, from_server$field);
			}
			if (hasShowPos) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, show_pos$field);
			}
			if (hasFromCareer) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, from_career$field);
			}
			if (hasFromVipType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, from_vip_type$field);
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
			var from_name$count:uint = 0;
			var from_gender$count:uint = 0;
			var from_vip_lv$count:uint = 0;
			var from_server$count:uint = 0;
			var show_pos$count:uint = 0;
			var from_career$count:uint = 0;
			var from_vip_type$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (channel$count != 0) {
						throw new flash.errors.IOError('Bad data format: SForwardChatMsg.channel cannot be set twice.');
					}
					++channel$count;
					this.channel = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (msg$count != 0) {
						throw new flash.errors.IOError('Bad data format: SForwardChatMsg.msg cannot be set twice.');
					}
					++msg$count;
					this.msg = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (from_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SForwardChatMsg.fromId cannot be set twice.');
					}
					++from_id$count;
					this.fromId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (from_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SForwardChatMsg.fromName cannot be set twice.');
					}
					++from_name$count;
					this.fromName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (from_gender$count != 0) {
						throw new flash.errors.IOError('Bad data format: SForwardChatMsg.fromGender cannot be set twice.');
					}
					++from_gender$count;
					this.fromGender = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (from_vip_lv$count != 0) {
						throw new flash.errors.IOError('Bad data format: SForwardChatMsg.fromVipLv cannot be set twice.');
					}
					++from_vip_lv$count;
					this.fromVipLv = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (from_server$count != 0) {
						throw new flash.errors.IOError('Bad data format: SForwardChatMsg.fromServer cannot be set twice.');
					}
					++from_server$count;
					this.fromServer = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (show_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: SForwardChatMsg.showPos cannot be set twice.');
					}
					++show_pos$count;
					this.showPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (from_career$count != 0) {
						throw new flash.errors.IOError('Bad data format: SForwardChatMsg.fromCareer cannot be set twice.');
					}
					++from_career$count;
					this.fromCareer = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 10:
					if (from_vip_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: SForwardChatMsg.fromVipType cannot be set twice.');
					}
					++from_vip_type$count;
					this.fromVipType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
