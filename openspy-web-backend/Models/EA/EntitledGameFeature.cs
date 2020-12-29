﻿using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace CoreWeb.Models.EA
{
    public class EntitledGameFeature
    {

        public int GameFeatureId { get; set; }
        public int Status { get; set; }
        public System.DateTime? EntitlementExpirationDate { get; set; }
        public string Message { get; set; }
        public int? EntitlementExpirationDays { get; set; }
    }
}
