{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Creative IT. All rights reserved.                              }
{ Licensed to Optimale Systemer AS.                                            }
{                                                                              }
{ For the latest version of this spec, see                                     }
{ http://www.khronos.org/registry/typedarray/specs/latest/                     }
{                                                                              }
{ **************************************************************************** }

unit w3c.TypedArray;

{------------------------------------------------------------------------------}
{ Author:    Eric Grange                                                       }
{ Updated:   2013.01.21 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

type
   ArrayBuffer = class external 'ArrayBuffer'
      byteLength : Integer; // Read Only
      function  Slice(aBegin : Integer; aEnd : Integer) : ArrayBuffer; external 'slice';
      constructor Create(aLength : Integer);
   end;

   JArrayBufferView = class external
      buffer : JArrayBuffer; // Read Only
      byteOffset : Integer; // Read Only
      byteLength : Integer; // Read Only
   end;

   JTypedArray = class external (JArrayBufferView)
      BYTES_PER_ELEMENT : Integer; // Read Only

      &length : Integer; // Read Only

      procedure Set(aArray : JTypedArrayJTypedArray; offset : Integer); overload; external 'set';

      constructor Create(aLength : Integer); overload;
      constructor Create(aArray : JTypedArrayJTypedArray); overload;
      constructor Create(buffer : ArrayBufferArrayBuffer; byteOffset, aLength : Integer); overload;
   end;

   JIntegerTypedArray = class abstract external (JTypedArray)
      function [](index : Integer) : Integer; external array;
      procedure [](index : Integer; value : Integer); external array;
      property Items$7[index : Integer] : Integer read [] write []; default;

      procedure Set(aArray : array of Integer; offset : Integer); overload; external 'set';

      constructor Create(aArray : array of Integer); overload;
   end;

   JInt8Array = class external 'Int8Array' (JIntegerTypedArray)
      const BYTES_PER_ELEMENT = 1;
      function  SubArray(aBegin, aEnd : Integer) : JInt8Array; external 'subarray';
   end;

   JUint8Array = class external 'Uint8Array' (JIntegerTypedArray)
      const BYTES_PER_ELEMENT = 1;
      function  SubArray(aBegin, aEnd : Integer) : JUint8Array; external 'subarray';
   end;

   Uint8ClampedArray = class external 'Uint8ClampedArray' (JIntegerTypedArray)
      const BYTES_PER_ELEMENT$1 = 1;
      function  SubArray(aBegin, aEnd : Integer) : Uint8ClampedArray; external 'subarray';
   end;

   JInt16Array = class external 'Int16Array' (JIntegerTypedArray)
      const BYTES_PER_ELEMENT = 2;
      function  SubArray(aBegin, aEnd : Integer) : JInt16Array; external 'subarray';
   end;

   JUint16Array = class external 'Uint16Array' (JIntegerTypedArray)
      const BYTES_PER_ELEMENT = 2;
      function  SubArray(aBegin, aEnd : Integer) : JUint16Array; external 'subarray';
   end;

   JInt32Array = class external 'Int32Array' (JIntegerTypedArray)
      const BYTES_PER_ELEMENT = 4;
      function  SubArray(aBegin, aEnd : Integer) : JInt32Array; external 'subarray';
   end;

   JUint32Array = class external 'Uint32Array' (JIntegerTypedArray)
      const BYTES_PER_ELEMENT = 4;
      function  SubArray(aBegin, aEnd : Integer) : JUint32Array; external 'subarray';
   end;

   JFloatTypedArray = class abstract external (JTypedArray)
      function GetItems(index : Integer) : Float; external array;
      procedure SetItems(index : Integer; value : Float); external array;
      property Items[index : Integer] : Float read getItems write setItems; default;

      procedure Set(aArray : array of Float; offset : Integer); overload; external 'set';

      constructor Create(aArray : array of Float); overload;
   end;

   JFloat32Array = class external 'Float32Array' (JFloatTypedArray)
      const BYTES_PER_ELEMENT = 4;
      function  SubArray(aBegin, aEnd : Integer) : JFloat32Array; external 'subarray';
   end;

   JFloat64Array = class external 'Float64Array' (JFloatTypedArray)
      const BYTES_PER_ELEMENT = 8;
      function  SubArray(aBegin, aEnd : Integer) : JFloat64Array; external 'subarray';
   end;


   JDataView = class external (JArrayBufferView)

      constructor Create(buffer : JArrayBuffer; byteOffset, byteLength : Integer);
      // Gets the value of the given type at the specified byte offset
      // from the start of the view. There is no alignment constraint;
      // multi-byte values may be fetched from any offset.
      //
      // For multi-byte values, the littleEndian argument
      // indicates whether a big-endian or little-endian value should be
      // read. If false or undefined, a big-endian value is read.
      //
      // These methods raise an exception if they would read
      // beyond the end of the view.
      function  getInt8(byteOffset : Integer) : Integer;
      function  getUint8(byteOffset : Integer) : Integer;
      function  getInt16(byteOffset : Integer; littleEndian : Boolean) : Integer;
      function  getUint16(byteOffset : Integer; littleEndian : Boolean) : Integer;
      function  getInt32(byteOffset : Integer; littleEndian : Boolean) : Integer;
      function  getUint32(byteOffset : Integer; littleEndian : Boolean) : Integer;
      function  getFloat32(byteOffset : Integer; littleEndian : Boolean) : Float;
      function  getFloat64(byteOffset : Integer; littleEndian : Boolean) : Float;

      // Stores a value of the given type at the specified byte offset
      // from the start of the view. There is no alignment constraint;
      // multi-byte values may be stored at any offset.
      //
      // For multi-byte values, the littleEndian argument
      // indicates whether the value should be stored in big-endian or
      // little-endian byte order. If false or undefined, the value is
      // stored in big-endian byte order.
      //
      // These methods raise an exception if they would write
      // beyond the end of the view.
      procedure setInt8(byteOffset : Integer; value : Integer);
      procedure setUint8(byteOffset : Integer; value : Integer);
      procedure setInt16(byteOffset : Integer; value : Integer; littleEndian : Boolean);
      procedure setUint16(byteOffset : Integer; value : Integer; littleEndian : Boolean);
      procedure setInt32(byteOffset : Integer; value : Integer; littleEndian : Boolean);
      procedure setUint32(byteOffset : Integer; value : Integer; littleEndian : Boolean);
      procedure setFloat32(byteOffset : Integer; value : Float; littleEndian : Boolean);
      procedure setFloat64(byteOffset : Integer; value : Float; littleEndian : Boolean);
   end;

implementation

end.
