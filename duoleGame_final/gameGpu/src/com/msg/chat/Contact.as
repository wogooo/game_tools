package com.msg.chat {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.chat.Relation;
	import com.msg.enumdef.Gender;
	import com.msg.enumdef.Career;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class Contact extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RELATION:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.chat.Contact.relation", "relation", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.chat.Relation);

		public var relation:int;

		/**
		 *  @private
		 */
		public static const DY_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.Contact.dy_id", "dyId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var dyId:int;

		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.chat.Contact.name", "name", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var name:String;

		/**
		 *  @private
		 */
		public static const LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.Contact.level", "level", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var level:int;

		/**
		 *  @private
		 */
		public static const CAREER:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.chat.Contact.career", "career", (5 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.Career);

		public var career:int;

		/**
		 *  @private
		 */
		public static const GENDER:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.chat.Contact.gender", "gender", (6 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.Gender);

		public var gender:int;

		/**
		 *  @private
		 */
		public static const ONLINE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.Contact.online", "online", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		public var online:int;

		/**
		 *  @private
		 */
		public static const GUILD:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.chat.Contact.guild", "guild", (8 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var guild$field:String;

		public function clearGuild():void {
			guild$field = null;
		}

		public function get hasGuild():Boolean {
			return guild$field != null;
		}

		public function set guild(value:String):void {
			guild$field = value;
		}

		public function get guild():String {
			return guild$field;
		}

		/**
		 *  @private
		 */
		public static const VIP_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.Contact.vip_level", "vipLevel", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var vip_level$field:int;

		private var hasField$0:uint = 0;

		public function clearVipLevel():void {
			hasField$0 &= 0xfffffffe;
			vip_level$field = new int();
		}

		public function get hasVipLevel():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set vipLevel(value:int):void {
			hasField$0 |= 0x1;
			vip_level$field = value;
		}

		public function get vipLevel():int {
			return vip_level$field;
		}

		/**
		 *  @private
		 */
		public static const VIP_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.Contact.vip_type", "vipType", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var vip_type$field:int;

		public function clearVipType():void {
			hasField$0 &= 0xfffffffd;
			vip_type$field = new int();
		}

		public function get hasVipType():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set vipType(value:int):void {
			hasField$0 |= 0x2;
			vip_type$field = value;
		}

		public function get vipType():int {
			return vip_type$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.relation);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.dyId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.name);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.level);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.career);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.gender);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.online);
			if (hasGuild) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, guild$field);
			}
			if (hasVipLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, vip_level$field);
			}
			if (hasVipType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, vip_type$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var relation$count:uint = 0;
			var dy_id$count:uint = 0;
			var name$count:uint = 0;
			var level$count:uint = 0;
			var career$count:uint = 0;
			var gender$count:uint = 0;
			var online$count:uint = 0;
			var guild$count:uint = 0;
			var vip_level$count:uint = 0;
			var vip_type$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (relation$count != 0) {
						throw new flash.errors.IOError('Bad data format: Contact.relation cannot be set twice.');
					}
					++relation$count;
					this.relation = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (dy_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: Contact.dyId cannot be set twice.');
					}
					++dy_id$count;
					this.dyId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: Contact.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: Contact.level cannot be set twice.');
					}
					++level$count;
					this.level = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (career$count != 0) {
						throw new flash.errors.IOError('Bad data format: Contact.career cannot be set twice.');
					}
					++career$count;
					this.career = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 6:
					if (gender$count != 0) {
						throw new flash.errors.IOError('Bad data format: Contact.gender cannot be set twice.');
					}
					++gender$count;
					this.gender = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 7:
					if (online$count != 0) {
						throw new flash.errors.IOError('Bad data format: Contact.online cannot be set twice.');
					}
					++online$count;
					this.online = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (guild$count != 0) {
						throw new flash.errors.IOError('Bad data format: Contact.guild cannot be set twice.');
					}
					++guild$count;
					this.guild = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 9:
					if (vip_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: Contact.vipLevel cannot be set twice.');
					}
					++vip_level$count;
					this.vipLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 10:
					if (vip_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: Contact.vipType cannot be set twice.');
					}
					++vip_type$count;
					this.vipType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
