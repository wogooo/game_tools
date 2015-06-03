package com.msg.item {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.enumdef.RspMsg;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SEquipDeftRsp extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RSP:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.item.SEquipDeftRsp.rsp", "rsp", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.RspMsg);

		public var rsp:int;

		/**
		 *  @private
		 */
		public static const APP_ATTR_T1:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SEquipDeftRsp.app_attr_t1", "appAttrT1", (15 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_t1$field:int;

		private var hasField$0:uint = 0;

		public function clearAppAttrT1():void {
			hasField$0 &= 0xfffffffe;
			app_attr_t1$field = new int();
		}

		public function get hasAppAttrT1():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set appAttrT1(value:int):void {
			hasField$0 |= 0x1;
			app_attr_t1$field = value;
		}

		public function get appAttrT1():int {
			return app_attr_t1$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_V1:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.msg.item.SEquipDeftRsp.app_attr_v1", "appAttrV1", (16 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var app_attr_v1$field:Number;

		public function clearAppAttrV1():void {
			hasField$0 &= 0xfffffffd;
			app_attr_v1$field = new Number();
		}

		public function get hasAppAttrV1():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set appAttrV1(value:Number):void {
			hasField$0 |= 0x2;
			app_attr_v1$field = value;
		}

		public function get appAttrV1():Number {
			return app_attr_v1$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_C1:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.msg.item.SEquipDeftRsp.app_attr_c1", "appAttrC1", (17 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_c1$field:uint;

		public function clearAppAttrC1():void {
			hasField$0 &= 0xfffffffb;
			app_attr_c1$field = new uint();
		}

		public function get hasAppAttrC1():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set appAttrC1(value:uint):void {
			hasField$0 |= 0x4;
			app_attr_c1$field = value;
		}

		public function get appAttrC1():uint {
			return app_attr_c1$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_L1:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.item.SEquipDeftRsp.app_attr_l1", "appAttrL1", (18 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_l1$field:Boolean;

		public function clearAppAttrL1():void {
			hasField$0 &= 0xfffffff7;
			app_attr_l1$field = new Boolean();
		}

		public function get hasAppAttrL1():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set appAttrL1(value:Boolean):void {
			hasField$0 |= 0x8;
			app_attr_l1$field = value;
		}

		public function get appAttrL1():Boolean {
			return app_attr_l1$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_T2:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SEquipDeftRsp.app_attr_t2", "appAttrT2", (19 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_t2$field:int;

		public function clearAppAttrT2():void {
			hasField$0 &= 0xffffffef;
			app_attr_t2$field = new int();
		}

		public function get hasAppAttrT2():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set appAttrT2(value:int):void {
			hasField$0 |= 0x10;
			app_attr_t2$field = value;
		}

		public function get appAttrT2():int {
			return app_attr_t2$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_V2:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.msg.item.SEquipDeftRsp.app_attr_v2", "appAttrV2", (20 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var app_attr_v2$field:Number;

		public function clearAppAttrV2():void {
			hasField$0 &= 0xffffffdf;
			app_attr_v2$field = new Number();
		}

		public function get hasAppAttrV2():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set appAttrV2(value:Number):void {
			hasField$0 |= 0x20;
			app_attr_v2$field = value;
		}

		public function get appAttrV2():Number {
			return app_attr_v2$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_C2:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.msg.item.SEquipDeftRsp.app_attr_c2", "appAttrC2", (21 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_c2$field:uint;

		public function clearAppAttrC2():void {
			hasField$0 &= 0xffffffbf;
			app_attr_c2$field = new uint();
		}

		public function get hasAppAttrC2():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set appAttrC2(value:uint):void {
			hasField$0 |= 0x40;
			app_attr_c2$field = value;
		}

		public function get appAttrC2():uint {
			return app_attr_c2$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_L2:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.item.SEquipDeftRsp.app_attr_l2", "appAttrL2", (22 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_l2$field:Boolean;

		public function clearAppAttrL2():void {
			hasField$0 &= 0xffffff7f;
			app_attr_l2$field = new Boolean();
		}

		public function get hasAppAttrL2():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set appAttrL2(value:Boolean):void {
			hasField$0 |= 0x80;
			app_attr_l2$field = value;
		}

		public function get appAttrL2():Boolean {
			return app_attr_l2$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_T3:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SEquipDeftRsp.app_attr_t3", "appAttrT3", (23 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_t3$field:int;

		public function clearAppAttrT3():void {
			hasField$0 &= 0xfffffeff;
			app_attr_t3$field = new int();
		}

		public function get hasAppAttrT3():Boolean {
			return (hasField$0 & 0x100) != 0;
		}

		public function set appAttrT3(value:int):void {
			hasField$0 |= 0x100;
			app_attr_t3$field = value;
		}

		public function get appAttrT3():int {
			return app_attr_t3$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_V3:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.msg.item.SEquipDeftRsp.app_attr_v3", "appAttrV3", (24 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var app_attr_v3$field:Number;

		public function clearAppAttrV3():void {
			hasField$0 &= 0xfffffdff;
			app_attr_v3$field = new Number();
		}

		public function get hasAppAttrV3():Boolean {
			return (hasField$0 & 0x200) != 0;
		}

		public function set appAttrV3(value:Number):void {
			hasField$0 |= 0x200;
			app_attr_v3$field = value;
		}

		public function get appAttrV3():Number {
			return app_attr_v3$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_C3:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.msg.item.SEquipDeftRsp.app_attr_c3", "appAttrC3", (25 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_c3$field:uint;

		public function clearAppAttrC3():void {
			hasField$0 &= 0xfffffbff;
			app_attr_c3$field = new uint();
		}

		public function get hasAppAttrC3():Boolean {
			return (hasField$0 & 0x400) != 0;
		}

		public function set appAttrC3(value:uint):void {
			hasField$0 |= 0x400;
			app_attr_c3$field = value;
		}

		public function get appAttrC3():uint {
			return app_attr_c3$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_L3:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.item.SEquipDeftRsp.app_attr_l3", "appAttrL3", (26 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_l3$field:Boolean;

		public function clearAppAttrL3():void {
			hasField$0 &= 0xfffff7ff;
			app_attr_l3$field = new Boolean();
		}

		public function get hasAppAttrL3():Boolean {
			return (hasField$0 & 0x800) != 0;
		}

		public function set appAttrL3(value:Boolean):void {
			hasField$0 |= 0x800;
			app_attr_l3$field = value;
		}

		public function get appAttrL3():Boolean {
			return app_attr_l3$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_T4:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SEquipDeftRsp.app_attr_t4", "appAttrT4", (27 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_t4$field:int;

		public function clearAppAttrT4():void {
			hasField$0 &= 0xffffefff;
			app_attr_t4$field = new int();
		}

		public function get hasAppAttrT4():Boolean {
			return (hasField$0 & 0x1000) != 0;
		}

		public function set appAttrT4(value:int):void {
			hasField$0 |= 0x1000;
			app_attr_t4$field = value;
		}

		public function get appAttrT4():int {
			return app_attr_t4$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_V4:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.msg.item.SEquipDeftRsp.app_attr_v4", "appAttrV4", (28 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var app_attr_v4$field:Number;

		public function clearAppAttrV4():void {
			hasField$0 &= 0xffffdfff;
			app_attr_v4$field = new Number();
		}

		public function get hasAppAttrV4():Boolean {
			return (hasField$0 & 0x2000) != 0;
		}

		public function set appAttrV4(value:Number):void {
			hasField$0 |= 0x2000;
			app_attr_v4$field = value;
		}

		public function get appAttrV4():Number {
			return app_attr_v4$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_C4:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.msg.item.SEquipDeftRsp.app_attr_c4", "appAttrC4", (29 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_c4$field:uint;

		public function clearAppAttrC4():void {
			hasField$0 &= 0xffffbfff;
			app_attr_c4$field = new uint();
		}

		public function get hasAppAttrC4():Boolean {
			return (hasField$0 & 0x4000) != 0;
		}

		public function set appAttrC4(value:uint):void {
			hasField$0 |= 0x4000;
			app_attr_c4$field = value;
		}

		public function get appAttrC4():uint {
			return app_attr_c4$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_L4:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.item.SEquipDeftRsp.app_attr_l4", "appAttrL4", (30 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_l4$field:Boolean;

		public function clearAppAttrL4():void {
			hasField$0 &= 0xffff7fff;
			app_attr_l4$field = new Boolean();
		}

		public function get hasAppAttrL4():Boolean {
			return (hasField$0 & 0x8000) != 0;
		}

		public function set appAttrL4(value:Boolean):void {
			hasField$0 |= 0x8000;
			app_attr_l4$field = value;
		}

		public function get appAttrL4():Boolean {
			return app_attr_l4$field;
		}

		/**
		 *  @private
		 */
		public static const DEFT_LOCK_NUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SEquipDeftRsp.deft_lock_num", "deftLockNum", (31 << 3) | com.netease.protobuf.WireType.VARINT);

		private var deft_lock_num$field:int;

		public function clearDeftLockNum():void {
			hasField$0 &= 0xfffeffff;
			deft_lock_num$field = new int();
		}

		public function get hasDeftLockNum():Boolean {
			return (hasField$0 & 0x10000) != 0;
		}

		public function set deftLockNum(value:int):void {
			hasField$0 |= 0x10000;
			deft_lock_num$field = value;
		}

		public function get deftLockNum():int {
			return deft_lock_num$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.rsp);
			if (hasAppAttrT1) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, app_attr_t1$field);
			}
			if (hasAppAttrV1) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 16);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, app_attr_v1$field);
			}
			if (hasAppAttrC1) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 17);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, app_attr_c1$field);
			}
			if (hasAppAttrL1) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 18);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, app_attr_l1$field);
			}
			if (hasAppAttrT2) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 19);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, app_attr_t2$field);
			}
			if (hasAppAttrV2) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 20);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, app_attr_v2$field);
			}
			if (hasAppAttrC2) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 21);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, app_attr_c2$field);
			}
			if (hasAppAttrL2) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 22);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, app_attr_l2$field);
			}
			if (hasAppAttrT3) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 23);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, app_attr_t3$field);
			}
			if (hasAppAttrV3) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 24);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, app_attr_v3$field);
			}
			if (hasAppAttrC3) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 25);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, app_attr_c3$field);
			}
			if (hasAppAttrL3) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 26);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, app_attr_l3$field);
			}
			if (hasAppAttrT4) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 27);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, app_attr_t4$field);
			}
			if (hasAppAttrV4) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 28);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, app_attr_v4$field);
			}
			if (hasAppAttrC4) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 29);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, app_attr_c4$field);
			}
			if (hasAppAttrL4) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 30);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, app_attr_l4$field);
			}
			if (hasDeftLockNum) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 31);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, deft_lock_num$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var rsp$count:uint = 0;
			var app_attr_t1$count:uint = 0;
			var app_attr_v1$count:uint = 0;
			var app_attr_c1$count:uint = 0;
			var app_attr_l1$count:uint = 0;
			var app_attr_t2$count:uint = 0;
			var app_attr_v2$count:uint = 0;
			var app_attr_c2$count:uint = 0;
			var app_attr_l2$count:uint = 0;
			var app_attr_t3$count:uint = 0;
			var app_attr_v3$count:uint = 0;
			var app_attr_c3$count:uint = 0;
			var app_attr_l3$count:uint = 0;
			var app_attr_t4$count:uint = 0;
			var app_attr_v4$count:uint = 0;
			var app_attr_c4$count:uint = 0;
			var app_attr_l4$count:uint = 0;
			var deft_lock_num$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (rsp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.rsp cannot be set twice.');
					}
					++rsp$count;
					this.rsp = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 15:
					if (app_attr_t1$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrT1 cannot be set twice.');
					}
					++app_attr_t1$count;
					this.appAttrT1 = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 16:
					if (app_attr_v1$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrV1 cannot be set twice.');
					}
					++app_attr_v1$count;
					this.appAttrV1 = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 17:
					if (app_attr_c1$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrC1 cannot be set twice.');
					}
					++app_attr_c1$count;
					this.appAttrC1 = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 18:
					if (app_attr_l1$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrL1 cannot be set twice.');
					}
					++app_attr_l1$count;
					this.appAttrL1 = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 19:
					if (app_attr_t2$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrT2 cannot be set twice.');
					}
					++app_attr_t2$count;
					this.appAttrT2 = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 20:
					if (app_attr_v2$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrV2 cannot be set twice.');
					}
					++app_attr_v2$count;
					this.appAttrV2 = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 21:
					if (app_attr_c2$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrC2 cannot be set twice.');
					}
					++app_attr_c2$count;
					this.appAttrC2 = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 22:
					if (app_attr_l2$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrL2 cannot be set twice.');
					}
					++app_attr_l2$count;
					this.appAttrL2 = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 23:
					if (app_attr_t3$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrT3 cannot be set twice.');
					}
					++app_attr_t3$count;
					this.appAttrT3 = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 24:
					if (app_attr_v3$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrV3 cannot be set twice.');
					}
					++app_attr_v3$count;
					this.appAttrV3 = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 25:
					if (app_attr_c3$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrC3 cannot be set twice.');
					}
					++app_attr_c3$count;
					this.appAttrC3 = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 26:
					if (app_attr_l3$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrL3 cannot be set twice.');
					}
					++app_attr_l3$count;
					this.appAttrL3 = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 27:
					if (app_attr_t4$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrT4 cannot be set twice.');
					}
					++app_attr_t4$count;
					this.appAttrT4 = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 28:
					if (app_attr_v4$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrV4 cannot be set twice.');
					}
					++app_attr_v4$count;
					this.appAttrV4 = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 29:
					if (app_attr_c4$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrC4 cannot be set twice.');
					}
					++app_attr_c4$count;
					this.appAttrC4 = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 30:
					if (app_attr_l4$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.appAttrL4 cannot be set twice.');
					}
					++app_attr_l4$count;
					this.appAttrL4 = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 31:
					if (deft_lock_num$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEquipDeftRsp.deftLockNum cannot be set twice.');
					}
					++deft_lock_num$count;
					this.deftLockNum = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
