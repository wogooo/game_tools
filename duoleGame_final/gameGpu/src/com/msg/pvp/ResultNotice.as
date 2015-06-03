package com.msg.pvp {
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
	public dynamic final class ResultNotice extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const NOTICE_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pvp.ResultNotice.notice_type", "noticeType", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var noticeType:int;

		/**
		 *  @private
		 */
		public static const FIRST_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.pvp.ResultNotice.first_name", "firstName", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var first_name$field:String;

		public function clearFirstName():void {
			first_name$field = null;
		}

		public function get hasFirstName():Boolean {
			return first_name$field != null;
		}

		public function set firstName(value:String):void {
			first_name$field = value;
		}

		public function get firstName():String {
			return first_name$field;
		}

		/**
		 *  @private
		 */
		public static const SECOND_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.pvp.ResultNotice.second_name", "secondName", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var second_name$field:String;

		public function clearSecondName():void {
			second_name$field = null;
		}

		public function get hasSecondName():Boolean {
			return second_name$field != null;
		}

		public function set secondName(value:String):void {
			second_name$field = value;
		}

		public function get secondName():String {
			return second_name$field;
		}

		/**
		 *  @private
		 */
		public static const THIRD_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.pvp.ResultNotice.third_name", "thirdName", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var third_name$field:String;

		public function clearThirdName():void {
			third_name$field = null;
		}

		public function get hasThirdName():Boolean {
			return third_name$field != null;
		}

		public function set thirdName(value:String):void {
			third_name$field = value;
		}

		public function get thirdName():String {
			return third_name$field;
		}

		/**
		 *  @private
		 */
		public static const GUILD_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.pvp.ResultNotice.guild_name", "guildName", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var guild_name$field:String;

		public function clearGuildName():void {
			guild_name$field = null;
		}

		public function get hasGuildName():Boolean {
			return guild_name$field != null;
		}

		public function set guildName(value:String):void {
			guild_name$field = value;
		}

		public function get guildName():String {
			return guild_name$field;
		}

		/**
		 *  @private
		 */
		public static const CAMP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pvp.ResultNotice.camp", "camp", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var camp$field:int;

		private var hasField$0:uint = 0;

		public function clearCamp():void {
			hasField$0 &= 0xfffffffe;
			camp$field = new int();
		}

		public function get hasCamp():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set camp(value:int):void {
			hasField$0 |= 0x1;
			camp$field = value;
		}

		public function get camp():int {
			return camp$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.noticeType);
			if (hasFirstName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, first_name$field);
			}
			if (hasSecondName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, second_name$field);
			}
			if (hasThirdName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, third_name$field);
			}
			if (hasGuildName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, guild_name$field);
			}
			if (hasCamp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, camp$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var notice_type$count:uint = 0;
			var first_name$count:uint = 0;
			var second_name$count:uint = 0;
			var third_name$count:uint = 0;
			var guild_name$count:uint = 0;
			var camp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (notice_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: ResultNotice.noticeType cannot be set twice.');
					}
					++notice_type$count;
					this.noticeType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (first_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: ResultNotice.firstName cannot be set twice.');
					}
					++first_name$count;
					this.firstName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (second_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: ResultNotice.secondName cannot be set twice.');
					}
					++second_name$count;
					this.secondName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (third_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: ResultNotice.thirdName cannot be set twice.');
					}
					++third_name$count;
					this.thirdName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (guild_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: ResultNotice.guildName cannot be set twice.');
					}
					++guild_name$count;
					this.guildName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 6:
					if (camp$count != 0) {
						throw new flash.errors.IOError('Bad data format: ResultNotice.camp cannot be set twice.');
					}
					++camp$count;
					this.camp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
