package com.msg.divine_pulse_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.divine_pulse_pro.FailedType;
	import com.msg.enumdef.RspMsg;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SDivinePulseRsp extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RSP:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.divine_pulse_pro.SDivinePulseRsp.rsp", "rsp", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.RspMsg);

		public var rsp:int;

		/**
		 *  @private
		 */
		public static const ERRNUM:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.divine_pulse_pro.SDivinePulseRsp.errnum", "errnum", (2 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.divine_pulse_pro.FailedType);

		private var errnum$field:int;

		private var hasField$0:uint = 0;

		public function clearErrnum():void {
			hasField$0 &= 0xfffffffe;
			errnum$field = new int();
		}

		public function get hasErrnum():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set errnum(value:int):void {
			hasField$0 |= 0x1;
			errnum$field = value;
		}

		public function get errnum():int {
			return errnum$field;
		}

		/**
		 *  @private
		 */
		public static const DIVINE_PULSE_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.divine_pulse_pro.SDivinePulseRsp.divine_pulse_id", "divinePulseId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var divinePulseId:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.rsp);
			if (hasErrnum) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, errnum$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.divinePulseId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var rsp$count:uint = 0;
			var errnum$count:uint = 0;
			var divine_pulse_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (rsp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SDivinePulseRsp.rsp cannot be set twice.');
					}
					++rsp$count;
					this.rsp = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (errnum$count != 0) {
						throw new flash.errors.IOError('Bad data format: SDivinePulseRsp.errnum cannot be set twice.');
					}
					++errnum$count;
					this.errnum = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 3:
					if (divine_pulse_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SDivinePulseRsp.divinePulseId cannot be set twice.');
					}
					++divine_pulse_id$count;
					this.divinePulseId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
