package com.msg.skill_pro {
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
	public dynamic final class SBuffDamage extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const DY_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.SBuffDamage.dy_id", "dyId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var dyId:int;

		/**
		 *  @private
		 */
		public static const BUFF_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.SBuffDamage.buff_id", "buffId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var buffId:int;

		/**
		 *  @private
		 */
		public static const HP_CHANGE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.SBuffDamage.hp_change", "hpChange", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var hp_change$field:int;

		private var hasField$0:uint = 0;

		public function clearHpChange():void {
			hasField$0 &= 0xfffffffe;
			hp_change$field = new int();
		}

		public function get hasHpChange():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set hpChange(value:int):void {
			hasField$0 |= 0x1;
			hp_change$field = value;
		}

		public function get hpChange():int {
			return hp_change$field;
		}

		/**
		 *  @private
		 */
		public static const HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.SBuffDamage.hp", "hp", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var hp$field:int;

		public function clearHp():void {
			hasField$0 &= 0xfffffffd;
			hp$field = new int();
		}

		public function get hasHp():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set hp(value:int):void {
			hasField$0 |= 0x2;
			hp$field = value;
		}

		public function get hp():int {
			return hp$field;
		}

		/**
		 *  @private
		 */
		public static const MP_CHANGE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.SBuffDamage.mp_change", "mpChange", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mp_change$field:int;

		public function clearMpChange():void {
			hasField$0 &= 0xfffffffb;
			mp_change$field = new int();
		}

		public function get hasMpChange():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set mpChange(value:int):void {
			hasField$0 |= 0x4;
			mp_change$field = value;
		}

		public function get mpChange():int {
			return mp_change$field;
		}

		/**
		 *  @private
		 */
		public static const MP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.SBuffDamage.mp", "mp", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mp$field:int;

		public function clearMp():void {
			hasField$0 &= 0xfffffff7;
			mp$field = new int();
		}

		public function get hasMp():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set mp(value:int):void {
			hasField$0 |= 0x8;
			mp$field = value;
		}

		public function get mp():int {
			return mp$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.dyId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.buffId);
			if (hasHpChange) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, hp_change$field);
			}
			if (hasHp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, hp$field);
			}
			if (hasMpChange) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mp_change$field);
			}
			if (hasMp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mp$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var dy_id$count:uint = 0;
			var buff_id$count:uint = 0;
			var hp_change$count:uint = 0;
			var hp$count:uint = 0;
			var mp_change$count:uint = 0;
			var mp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (dy_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SBuffDamage.dyId cannot be set twice.');
					}
					++dy_id$count;
					this.dyId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (buff_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SBuffDamage.buffId cannot be set twice.');
					}
					++buff_id$count;
					this.buffId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (hp_change$count != 0) {
						throw new flash.errors.IOError('Bad data format: SBuffDamage.hpChange cannot be set twice.');
					}
					++hp_change$count;
					this.hpChange = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SBuffDamage.hp cannot be set twice.');
					}
					++hp$count;
					this.hp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (mp_change$count != 0) {
						throw new flash.errors.IOError('Bad data format: SBuffDamage.mpChange cannot be set twice.');
					}
					++mp_change$count;
					this.mpChange = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (mp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SBuffDamage.mp cannot be set twice.');
					}
					++mp$count;
					this.mp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
