package com.msg.actv {
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
	public dynamic final class SUseMoonWell extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CODE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.actv.SUseMoonWell.code", "code", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var code:int;

		/**
		 *  @private
		 */
		public static const HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.actv.SUseMoonWell.hp", "hp", (2 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const MP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.actv.SUseMoonWell.mp", "mp", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mp$field:int;

		public function clearMp():void {
			hasField$0 &= 0xfffffffd;
			mp$field = new int();
		}

		public function get hasMp():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set mp(value:int):void {
			hasField$0 |= 0x2;
			mp$field = value;
		}

		public function get mp():int {
			return mp$field;
		}

		/**
		 *  @private
		 */
		public static const GODESS_HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.actv.SUseMoonWell.godess_hp", "godessHp", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var godess_hp$field:int;

		public function clearGodessHp():void {
			hasField$0 &= 0xfffffffb;
			godess_hp$field = new int();
		}

		public function get hasGodessHp():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set godessHp(value:int):void {
			hasField$0 |= 0x4;
			godess_hp$field = value;
		}

		public function get godessHp():int {
			return godess_hp$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.code);
			if (hasHp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, hp$field);
			}
			if (hasMp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mp$field);
			}
			if (hasGodessHp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, godess_hp$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var code$count:uint = 0;
			var hp$count:uint = 0;
			var mp$count:uint = 0;
			var godess_hp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (code$count != 0) {
						throw new flash.errors.IOError('Bad data format: SUseMoonWell.code cannot be set twice.');
					}
					++code$count;
					this.code = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SUseMoonWell.hp cannot be set twice.');
					}
					++hp$count;
					this.hp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (mp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SUseMoonWell.mp cannot be set twice.');
					}
					++mp$count;
					this.mp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (godess_hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SUseMoonWell.godessHp cannot be set twice.');
					}
					++godess_hp$count;
					this.godessHp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
