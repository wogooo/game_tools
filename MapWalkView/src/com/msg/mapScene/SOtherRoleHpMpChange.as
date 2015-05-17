package com.msg.mapScene {
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
	public dynamic final class SOtherRoleHpMpChange extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const DY_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SOtherRoleHpMpChange.dy_id", "dyId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var dyId:int;

		/**
		 *  @private
		 */
		public static const HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SOtherRoleHpMpChange.hp", "hp", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var hp$field:int;

		private var hasField$0:uint = 0;

		public function clearHp():void {
			hasField$0 &= 0xfffffffe;
			hp$field = new int();
		}

		public function get hasHp():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set hp(value:int):void {
			hasField$0 |= 0x1;
			hp$field = value;
		}

		public function get hp():int {
			return hp$field;
		}

		/**
		 *  @private
		 */
		public static const HP_MAX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SOtherRoleHpMpChange.hp_max", "hpMax", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var hp_max$field:int;

		public function clearHpMax():void {
			hasField$0 &= 0xfffffffd;
			hp_max$field = new int();
		}

		public function get hasHpMax():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set hpMax(value:int):void {
			hasField$0 |= 0x2;
			hp_max$field = value;
		}

		public function get hpMax():int {
			return hp_max$field;
		}

		/**
		 *  @private
		 */
		public static const MP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SOtherRoleHpMpChange.mp", "mp", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mp$field:int;

		public function clearMp():void {
			hasField$0 &= 0xfffffffb;
			mp$field = new int();
		}

		public function get hasMp():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set mp(value:int):void {
			hasField$0 |= 0x4;
			mp$field = value;
		}

		public function get mp():int {
			return mp$field;
		}

		/**
		 *  @private
		 */
		public static const MP_MAX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SOtherRoleHpMpChange.mp_max", "mpMax", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mp_max$field:int;

		public function clearMpMax():void {
			hasField$0 &= 0xfffffff7;
			mp_max$field = new int();
		}

		public function get hasMpMax():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set mpMax(value:int):void {
			hasField$0 |= 0x8;
			mp_max$field = value;
		}

		public function get mpMax():int {
			return mp_max$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.dyId);
			if (hasHp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, hp$field);
			}
			if (hasHpMax) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, hp_max$field);
			}
			if (hasMp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mp$field);
			}
			if (hasMpMax) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mp_max$field);
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
			var hp$count:uint = 0;
			var hp_max$count:uint = 0;
			var mp$count:uint = 0;
			var mp_max$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (dy_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherRoleHpMpChange.dyId cannot be set twice.');
					}
					++dy_id$count;
					this.dyId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherRoleHpMpChange.hp cannot be set twice.');
					}
					++hp$count;
					this.hp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (hp_max$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherRoleHpMpChange.hpMax cannot be set twice.');
					}
					++hp_max$count;
					this.hpMax = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (mp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherRoleHpMpChange.mp cannot be set twice.');
					}
					++mp$count;
					this.mp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (mp_max$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherRoleHpMpChange.mpMax cannot be set twice.');
					}
					++mp_max$count;
					this.mpMax = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
