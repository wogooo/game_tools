package com.msg.login {
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
	public dynamic final class PlayerInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const DY_ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.msg.login.PlayerInfo.dy_id", "dyId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var dyId:uint;

		/**
		 *  @private
		 */
		public static const SEX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.sex", "sex", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var sex:int;

		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.login.PlayerInfo.name", "name", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var name:String;

		/**
		 *  @private
		 */
		public static const HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.hp", "hp", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var hp:int;

		/**
		 *  @private
		 */
		public static const EXP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.exp", "exp", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var exp:int;

		/**
		 *  @private
		 */
		public static const CAREER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.career", "career", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		public var career:int;

		/**
		 *  @private
		 */
		public static const LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.level", "level", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		public var level:int;

		/**
		 *  @private
		 */
		public static const MAX_HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.max_hp", "maxHp", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		public var maxHp:int;

		/**
		 *  @private
		 */
		public static const DIAMOND:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.diamond", "diamond", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		public var diamond:int;

		/**
		 *  @private
		 */
		public static const COUPON:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.coupon", "coupon", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		public var coupon:int;

		/**
		 *  @private
		 */
		public static const SILVER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.silver", "silver", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		public var silver:int;

		/**
		 *  @private
		 */
		public static const NOTE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.note", "note", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		public var note:int;

		/**
		 *  @private
		 */
		public static const SOCIATY:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.login.PlayerInfo.sociaty", "sociaty", (13 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var sociaty:String;

		/**
		 *  @private
		 */
		public static const ENERGY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.energy", "energy", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		public var energy:int;

		/**
		 *  @private
		 */
		public static const PK_VALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.pk_value", "pkValue", (15 << 3) | com.netease.protobuf.WireType.VARINT);

		public var pkValue:int;

		/**
		 *  @private
		 */
		public static const SEE_VALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.see_value", "seeValue", (16 << 3) | com.netease.protobuf.WireType.VARINT);

		public var seeValue:int;

		/**
		 *  @private
		 */
		public static const POTENTIAL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.potential", "potential", (17 << 3) | com.netease.protobuf.WireType.VARINT);

		public var potential:int;

		/**
		 *  @private
		 */
		public static const HONOUR:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.PlayerInfo.honour", "honour", (18 << 3) | com.netease.protobuf.WireType.VARINT);

		public var honour:int;

		/**
		 *  @private
		 */
		public static const TITLE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.login.PlayerInfo.title", "title", (19 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var title:String;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.dyId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.sex);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.name);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.hp);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.exp);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.career);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.level);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.maxHp);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.diamond);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.coupon);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.silver);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.note);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 13);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.sociaty);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.energy);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 15);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.pkValue);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 16);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.seeValue);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 17);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.potential);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 18);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.honour);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 19);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.title);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var dy_id$count:uint = 0;
			var sex$count:uint = 0;
			var name$count:uint = 0;
			var hp$count:uint = 0;
			var exp$count:uint = 0;
			var career$count:uint = 0;
			var level$count:uint = 0;
			var max_hp$count:uint = 0;
			var diamond$count:uint = 0;
			var coupon$count:uint = 0;
			var silver$count:uint = 0;
			var note$count:uint = 0;
			var sociaty$count:uint = 0;
			var energy$count:uint = 0;
			var pk_value$count:uint = 0;
			var see_value$count:uint = 0;
			var potential$count:uint = 0;
			var honour$count:uint = 0;
			var title$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (dy_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.dyId cannot be set twice.');
					}
					++dy_id$count;
					this.dyId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (sex$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.sex cannot be set twice.');
					}
					++sex$count;
					this.sex = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.hp cannot be set twice.');
					}
					++hp$count;
					this.hp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (exp$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.exp cannot be set twice.');
					}
					++exp$count;
					this.exp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (career$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.career cannot be set twice.');
					}
					++career$count;
					this.career = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.level cannot be set twice.');
					}
					++level$count;
					this.level = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (max_hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.maxHp cannot be set twice.');
					}
					++max_hp$count;
					this.maxHp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (diamond$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.diamond cannot be set twice.');
					}
					++diamond$count;
					this.diamond = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 10:
					if (coupon$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.coupon cannot be set twice.');
					}
					++coupon$count;
					this.coupon = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 11:
					if (silver$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.silver cannot be set twice.');
					}
					++silver$count;
					this.silver = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 12:
					if (note$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.note cannot be set twice.');
					}
					++note$count;
					this.note = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 13:
					if (sociaty$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.sociaty cannot be set twice.');
					}
					++sociaty$count;
					this.sociaty = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 14:
					if (energy$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.energy cannot be set twice.');
					}
					++energy$count;
					this.energy = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 15:
					if (pk_value$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.pkValue cannot be set twice.');
					}
					++pk_value$count;
					this.pkValue = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 16:
					if (see_value$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.seeValue cannot be set twice.');
					}
					++see_value$count;
					this.seeValue = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 17:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.potential cannot be set twice.');
					}
					++potential$count;
					this.potential = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 18:
					if (honour$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.honour cannot be set twice.');
					}
					++honour$count;
					this.honour = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 19:
					if (title$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerInfo.title cannot be set twice.');
					}
					++title$count;
					this.title = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
