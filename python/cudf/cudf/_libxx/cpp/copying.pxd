# Copyright (c) 2020, NVIDIA CORPORATION.

from rmm._lib.device_buffer cimport device_buffer

from libcpp cimport bool
from libc.stdint cimport int32_t
from libcpp.memory cimport unique_ptr
from libcpp.vector cimport vector

from cudf._libxx.cpp.column.column cimport column
from cudf._libxx.cpp.column.column_view cimport (
    column_view,
    mutable_column_view
)
from cudf._libxx.cpp.libcpp.functional cimport reference_wrapper
from cudf._libxx.cpp.scalar.scalar cimport scalar
from cudf._libxx.cpp.table.table cimport table
from cudf._libxx.cpp.table.table_view cimport table_view
from cudf._libxx.cpp.types cimport size_type

cdef extern from "cudf/copying.hpp" namespace "cudf::experimental" nogil:
    cdef unique_ptr[table] gather (
        const table_view& source_table,
        const column_view& gather_map
    ) except +

    cdef unique_ptr[column] shift(
        const column_view& input,
        size_type offset,
        const scalar& fill_values
    ) except +

    cdef unique_ptr[table] scatter (
        table_view source_table,
        column_view scatter_map,
        table_view target_table,
        bool bounds_check
    ) except +

    cdef unique_ptr[table] scatter (
        vector[unique_ptr[scalar]] source_scalars,
        column_view indices,
        table_view target,
        bool bounds_check
    ) except +

    cdef vector[unique_ptr[table]] scatter_to_tables (
        table_view source_table,
        column_view partition_map
    ) except +

    ctypedef enum mask_allocation_policy:
        NEVER 'cudf::experimental::mask_allocation_policy::NEVER',
        RETAIN 'cudf::experimental::mask_allocation_policy::RETAIN',
        ALWAYS 'cudf::experimental::mask_allocation_policy::ALWAYS'

    cdef unique_ptr[column] empty_like (
        column_view input_column
    ) except +

    cdef unique_ptr[column] allocate_like (
        column_view input_column,
        mask_allocation_policy policy
    ) except +

    cdef unique_ptr[column] allocate_like (
        column_view input_column,
        size_type size,
        mask_allocation_policy policy
    ) except +

    cdef unique_ptr[table] empty_like (
        table_view input_table
    ) except +

    cdef void copy_range_in_place (
        column_view input_column,
        mutable_column_view target_column,
        size_type input_begin,
        size_type input_end,
        size_type target_begin
    ) except +

    cdef unique_ptr[column] copy_range (
        column_view input_column,
        column_view target_column,
        size_type input_begin,
        size_type input_end,
        size_type target_begin
    ) except +

    cdef vector[column_view] slice (
        column_view input_column,
        vector[size_type] indices
    ) except +

    cdef vector[table_view] slice (
        table_view input_table,
        vector[size_type] indices
    ) except +

    cdef vector[column_view] split (
        column_view input_column,
        vector[size_type] splits
    ) except +

    cdef vector[table_view] split (
        table_view input_table,
        vector[size_type] splits
    ) except +

    cdef struct contiguous_split_result:
        table_view table
        vector[device_buffer] all_data

    cdef vector[contiguous_split_result] contiguous_split (
        table_view input_table,
        vector[size_type] splits
    ) except +

    cdef unique_ptr[column] copy_if_else (
        column_view lhs,
        column_view rhs,
        column_view boolean_mask
    ) except +

    cdef unique_ptr[column] copy_if_else (
        scalar lhs,
        column_view rhs,
        column_view boolean_mask
    ) except +

    cdef unique_ptr[column] copy_if_else (
        column_view lhs,
        scalar rhs,
        column_view boolean_mask
    ) except +

    cdef unique_ptr[column] copy_if_else (
        scalar lhs,
        scalar rhs,
        column_view boolean_mask
    ) except +

    cdef unique_ptr[table] boolean_mask_scatter (
        table_view input,
        table_view target,
        column_view boolean_mask
    ) except +

    cdef unique_ptr[table] boolean_mask_scatter (
        vector[reference_wrapper[scalar]] input,
        table_view target,
        column_view boolean_mask
    ) except +
